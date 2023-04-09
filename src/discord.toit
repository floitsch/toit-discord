// Copyright (C) 2023 Florian Loitsch.
// Use of this source code is governed by a MIT-style license that can be found
// in the LICENSE file.

/*
Discord API: https://discord.com/developers/docs/reference
*/

import certificate_roots
import encoding.json
import http
import log
import net

import .model
import .gateway_model
export *

/**
A library to implement a Discord bot.

Go to https://discord.com/developers.
Create a new application.
Go to the "Bot" tab.
Click "Add Bot".
Click "Yes, do it!".
Reset the token and copy it. Pass it as argument to the Discord client.
If you want to read messages, also enable the privileged gateway intents on the same page.
  Specifically, enable the "Message Content Intent".
Go to the "OAuth2" tab.
For authorization, there are two options:
- create a custom URL, or
- set the default authorization link. (Only works for public bots.)
The custom URL is faster for testing, but the default authorization link is
  more convenient for users.
In both cases, go to the "OAuth2" section.
For the custom URL, go to the URL Generator. Click on "bot" and select the
  permissions you want. Users who want to add the chatbot need to
  visit that URL.
For the default authorization link, go to the "General" tab, and change the
  Authorization Method to "In-app Authorization" in the "Default Authorization Link"
  section. Choose "bot" and the permissions the bot should have.
*/

INTENT_GUILDS ::= 1 << 0
INTENT_GUILD_MEMBERS ::= 1 << 1
INTENT_GUILD_MODERATION ::= 1 << 2
INTENT_GUILD_EMOJIS_AND_STICKERS ::= 1 << 3
INTENT_GUILD_INTEGRATIONS ::= 1 << 4
INTENT_GUILD_WEBHOOKS ::= 1 << 5
INTENT_GUILD_INVITES ::= 1 << 6
INTENT_GUILD_VOICE_STATES ::= 1 << 7
INTENT_GUILD_PRESENCES ::= 1 << 8
INTENT_GUILD_MESSAGES ::= 1 << 9
INTENT_GUILD_MESSAGE_REACTIONS ::= 1 << 10
INTENT_GUILD_MESSAGE_TYPING ::= 1 << 11
INTENT_DIRECT_MESSAGES ::= 1 << 12
INTENT_DIRECT_MESSAGE_REACTIONS ::= 1 << 13
INTENT_DIRECT_MESSAGE_TYPING ::= 1 << 14
INTENT_GUILD_MESSAGE_CONTENT ::= 1 << 15
INTENT_GUILD_SCHEDULED_EVENTS ::= 1 << 16
INTENT_AUTO_MODERATION_CONFIGURATION ::= 1 << 20
INTENT_AUTO_MODERATION_EXECUTION ::= 1 << 21

BOT_VERSION_ ::= "0.1"

API_HOST_ ::= "discord.com"
CERTIFICATE_ ::= certificate_roots.BALTIMORE_CYBERTRUST_ROOT
API_VERSION_ ::= "10"
API_PATH_ ::= "/api/v$API_VERSION_"

// https://discord.com/developers/docs/topics/gateway

/**
A gateway is a WebSocket connection to the Discord API.
*/
class Gateway:
  /** An event was dispatched. Sent by server. */
  static OP_DISPATCH ::= 0
  /** Fired periodically by the client to keep the connection alive. */
  static OP_HEARTBEAT ::= 1
  /** Starts a new session during the initial handshake. Sent by client. */
  static OP_IDENTIFY ::= 2
  /** Update the client's presence. Sent by client. */
  static OP_PRESENCE_UPDATE ::= 3
  /** Used to join/leave or move between voice channels. Sent by client. */
  static OP_VOICE_STATE_UPDATE ::= 4
  /** Resume a previous session that was disconnected. Sent by client. */
  static OP_RESUME ::= 6
  /** Request to reconnect and resume immediately. Sent by server. */
  static OP_RECONNECT ::= 7
  /** Request information about offline guild members in a large guild. Sent by client. */
  static OP_REQUEST_GUILD_MEMBERS ::= 8
  /** The session has been invalidated. Request to reconnect and identify/resume accordingly. Sent by server. */
  static OP_INVALID_SESSION ::= 9
  /** Sent immediately after connecting, contains the `heartbeat_interval` to use. Sent by server. */
  static OP_HELLO ::= 10
  /** Sent in response to receiving a heartbeat to acknowledge that it has been received. Sent by server. */
  static OP_HEARTBEAT_ACK ::= 11

  network_/net.Interface? := null
  websocket_/http.WebSocket? := null
  heartbeat_task_/Task? := null
  token_/string
  logger_/log.Logger

  /**
  Builds a gateway object.
  Generally, you should not need to call this constructor directly.
  */
  constructor --token/string --logger/log.Logger:
    token_ = token
    logger_ = logger

  /**
  Connects to the Gateway and starts listening for events.
  The $gateway_url argument is given by a call to "/gateway/bot" (see $Client.listen).
  */
  connect_and_listen --intents/int gateway_url/string [block]:
    session_id/string? := null
    resume_gateway_url/string? := null
    sequence_number/int? := null
    network_ = net.open
    try:
      while true:
        should_reconnect := false
        catch --unwind=(: not should_reconnect):
          if websocket_:
            websocket_.close
            websocket_ = null

          headers := http.Headers
          client := http.Client.tls network_
              --root_certificates=[certificate_roots.BALTIMORE_CYBERTRUST_ROOT]

          should_resume := session_id and sequence_number
          url := should_resume ? resume_gateway_url : gateway_url
          url_with_query := "$url/?v=$API_VERSION_&encoding=json"
          websocket_ = client.web_socket --uri=url_with_query --headers=headers

          if should_resume:
            logger_.info "trying to resume to gateway"
            resume_ session_id sequence_number
          else:
            logger_.info "trying to (re)connect to gateway"
            if heartbeat_task_:
              heartbeat_task_.cancel
              heartbeat_task_ = null
            sequence_number = null

            heartbeat_interval_ms := connect_ gateway_url intents
            jitter := random heartbeat_interval_ms
            heartbeat_task_ = task::
              sleep --ms=jitter
              while true:
                catch:
                  assert: OP_HEARTBEAT == 1
                  websocket_.send "{\"op\": 1, \"d\": $sequence_number}"
                  sleep --ms=heartbeat_interval_ms


          should_reconnect = true
          while data := websocket_.receive:
            logger_.debug "received" --tags={ "data": data }
            decoded := json.parse data
            event_sequence_number := decoded.get "s"
            if event_sequence_number:
              sequence_number = event_sequence_number

            if decoded["op"] == OP_INVALID_SESSION:
              if not decoded["d"]:
                // The inner 'd' key is a boolean that indicates whether the session
                // may be resumable.
                session_id = null
                resume_gateway_url = null
              break

            if decoded["op"] == OP_RECONNECT:
              logger_.info "request to reconnect"
              break

            if decoded["op"] == OP_HEARTBEAT_ACK:
              continue

            if decoded["op"] == OP_DISPATCH:
              event := Event.from_json decoded["t"] decoded["d"]

              if event is EventReady:
                ready := event as EventReady
                session_id = ready.session_id
                resume_gateway_url = ready.resume_gateway_url

              // Make sure the unused variables can be garbage collected.
              data = null
              decoded = null
              block.call event

          block.call EventDisconnected
    finally:
      close

  /** Connects and returns the heartbeat interval. */
  connect_ gateway_url/string intents/int -> int:
    hello := websocket_.receive
    decoded := json.parse hello
    if decoded["op"] != OP_HELLO:
      throw "Expected OP_HELLO, got $decoded"
    heartbeat_interval_ms := decoded["d"]["heartbeat_interval"]

    // Identify.
    identify/Identify? := Identify
        --token=token_
        --intents=intents
        --properties=ConnectionProperties
            --os="linux"
            --browser="Toit"
            --device="TBD"

    payload := json.stringify {
      "op": OP_IDENTIFY,
      "d": identify.to_json
    }
    websocket_.send payload
    return heartbeat_interval_ms

  resume_ session_id/string sequence_number/int:
    resume := Resume
        --token=token_
        --session_id=session_id
        --seq=sequence_number

    payload := json.stringify {
      "op": OP_RESUME,
      "d": resume.to_json
    }
    websocket_.send payload

  close --keep_network/bool=false -> none:
    if heartbeat_task_:
      heartbeat_task_.cancel
      heartbeat_task_ = null
    if websocket_:
      websocket_.close
      websocket_ = null
    if network_ and not keep_network:
      network_.close
      network_ = null

class Client:
  token_/string
  my_id_/string? := null
  client_/http.Client? := null
  network_/net.Interface? := null
  gateway_/Gateway? := null
  logger_/log.Logger

  constructor
      --token/string
      --logger/log.Logger=(log.default.with_level log.INFO_LEVEL):
    token_ = token
    logger_ = logger.with_name "discord"

  connect -> none:
    network_ = net.open
    client_ = http.Client.tls network_
      --root_certificates=[CERTIFICATE_]

  close -> none:
    if gateway_:
      gateway_.close
      gateway_ = null
    if client_:
      client_.close
      client_ = null
    if network_:
      network_.close
      network_ = null

  /**
  Starts a Gateway and listens for notifications.
  Automatically sends heartbeats to the server.
  Intercepts some messages that are only relevant to maintaining the
    gateway connection. Most notifications are passed to the given $block.

  Handling of new events is blocked until the $block returns. The $block
    should thus only take a short time to handle events.
  */
  listen --intents/int [block]:
    gateway_response := request_ "/gateway/bot"
    url := gateway_response["url"]
    gateway_ = Gateway --token=token_ --logger=(logger_.with_name "gateway")
    gateway_.connect_and_listen url
        --intents=intents
        block

  send_message message/string --channel_id/string:
    payload := {
      "content": "$message",
      "tts": false,
    }
    request_ "/channels/$channel_id/messages" --payload=payload

  /** Returns the $User object for the bot. */
  me -> User:
    return User.from_json (request_ "/users/@me")

  /** Returns a list of $Guild objects the bot is a member of. */
  guilds -> List:
    json_guilds := request_ "/users/@me/guilds"
    return json_guilds.map: Guild.from_json it

  /** Returns a list of $Channel objects in the given $guild_id. */
  channels guild_id/string -> List:
    channel_list := request_ "/guilds/$guild_id/channels"
    return channel_list.map: Channel.from_json it

  /** Returns the $Channel object for the given $channel_id. */
  channel channel_id/string -> Channel:
    channel_response := request_ "/channels/$channel_id"
    return Channel.from_json channel_response

  /** Triggers the typing indicator for the given $channel_id. */
  // TODO(florian): this function doesn't seem to work.
  // I got disconnected when I used it.
  trigger_typing --channel_id/string:
    request_ "/channels/$channel_id/typing" --method=http.POST

  /**
  Returns a list of $Message objects in the given $channel_id.
  If $limit is given, only the last $limit messages are returned.
  */
  messages channel_id/string --limit/int?=null -> List:
    path := "/channels/$channel_id/messages"
    if limit: path = "$path?limit=$limit"
    messages_response := request_ path
    return messages_response.map: Message.from_json it

  request_ -> any
      path/string
      --payload/Map?=null
      --method/string=(payload ? http.POST : http.GET):
    headers := http.Headers
    headers.add "Authorization" "Bot $token_"
    headers.add "User-Agent" "DiscordBot/$BOT_VERSION_ toit-discord"
    response/http.Response? := ?
    if payload:
      response = client_.post_json payload --host=API_HOST_ --path="$API_PATH_/$path" --headers=headers
    else:
      headers.add "Content-Type" "application/json"
      response = client_.get
          API_HOST_
          "$API_PATH_/$path"
          --headers=headers
    if response.status_code != 200:
      throw "HTTP error: $response.status_code"

    decoded := json.decode_stream response.body
    return decoded
