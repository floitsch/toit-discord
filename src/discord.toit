// Copyright (C) 2023 Florian Loitsch.
// Use of this source code is governed by a MIT-style license that can be found
// in the LICENSE file.

/*
Discord API: https://discord.com/developers/docs/reference
*/

import certificate-roots
import encoding.json
import http
import log
import net

import .model
import .gateway-model
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

INTENT-GUILDS ::= 1 << 0
INTENT-GUILD-MEMBERS ::= 1 << 1
INTENT-GUILD-MODERATION ::= 1 << 2
INTENT-GUILD-EMOJIS-AND-STICKERS ::= 1 << 3
INTENT-GUILD-INTEGRATIONS ::= 1 << 4
INTENT-GUILD-WEBHOOKS ::= 1 << 5
INTENT-GUILD-INVITES ::= 1 << 6
INTENT-GUILD-VOICE-STATES ::= 1 << 7
INTENT-GUILD-PRESENCES ::= 1 << 8
INTENT-GUILD-MESSAGES ::= 1 << 9
INTENT-GUILD-MESSAGE-REACTIONS ::= 1 << 10
INTENT-GUILD-MESSAGE-TYPING ::= 1 << 11
INTENT-DIRECT-MESSAGES ::= 1 << 12
INTENT-DIRECT-MESSAGE-REACTIONS ::= 1 << 13
INTENT-DIRECT-MESSAGE-TYPING ::= 1 << 14
INTENT-GUILD-MESSAGE-CONTENT ::= 1 << 15
INTENT-GUILD-SCHEDULED-EVENTS ::= 1 << 16
INTENT-AUTO-MODERATION-CONFIGURATION ::= 1 << 20
INTENT-AUTO-MODERATION-EXECUTION ::= 1 << 21

BOT-VERSION_ ::= "0.1"

API-HOST_ ::= "discord.com"
API-VERSION_ ::= "10"
API-PATH_ ::= "/api/v$API-VERSION_"

// https://discord.com/developers/docs/topics/gateway

/**
A gateway is a WebSocket connection to the Discord API.
*/
class Gateway:
  /** An event was dispatched. Sent by server. */
  static OP-DISPATCH ::= 0
  /** Fired periodically by the client to keep the connection alive. */
  static OP-HEARTBEAT ::= 1
  /** Starts a new session during the initial handshake. Sent by client. */
  static OP-IDENTIFY ::= 2
  /** Update the client's presence. Sent by client. */
  static OP-PRESENCE-UPDATE ::= 3
  /** Used to join/leave or move between voice channels. Sent by client. */
  static OP-VOICE-STATE-UPDATE ::= 4
  /** Resume a previous session that was disconnected. Sent by client. */
  static OP-RESUME ::= 6
  /** Request to reconnect and resume immediately. Sent by server. */
  static OP-RECONNECT ::= 7
  /** Request information about offline guild members in a large guild. Sent by client. */
  static OP-REQUEST-GUILD-MEMBERS ::= 8
  /** The session has been invalidated. Request to reconnect and identify/resume accordingly. Sent by server. */
  static OP-INVALID-SESSION ::= 9
  /** Sent immediately after connecting, contains the `heartbeat_interval` to use. Sent by server. */
  static OP-HELLO ::= 10
  /** Sent in response to receiving a heartbeat to acknowledge that it has been received. Sent by server. */
  static OP-HEARTBEAT-ACK ::= 11

  network_/net.Interface? := null
  websocket_/http.WebSocket? := null
  heartbeat-task_/Task? := null
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
  The $gateway-url argument is given by a call to "/gateway/bot" (see $Client.listen).
  */
  connect-and-listen --intents/int gateway-url/string [block]:
    session-id/string? := null
    resume-gateway-url/string? := null
    sequence-number/int? := null
    network_ = net.open
    try:
      while true:
        should-reconnect := false
        exception := catch --trace --unwind=(: not should-reconnect):
          if websocket_:
            websocket_.close
            websocket_ = null

          headers := http.Headers
          client := http.Client.tls network_

          should-resume := session-id and sequence-number
          url := should-resume ? resume-gateway-url : gateway-url
          url-with-query := "$url/?v=$API-VERSION_&encoding=json"
          websocket_ = client.web-socket --uri=url-with-query --headers=headers

          heartbeat-interval-ms/int := ?
          if should-resume:
            logger_.info "trying to resume to gateway" --tags={
              "session-id": session-id,
            }
            heartbeat-interval-ms = resume_ session-id sequence-number
            logger_.info "resumed" --tags={
              "heartbeat-interval": heartbeat-interval-ms,
            }
          else:
            logger_.info "trying to (re)connect to gateway"
            sequence-number = null

            heartbeat-interval-ms = connect_ gateway-url intents
            logger_.info "connected" --tags={
              "heartbeat-interval": heartbeat-interval-ms,
            }

          jitter := random heartbeat-interval-ms
          heartbeat-task_ = task::
            sleep --ms=jitter
            while true:
              catch --trace:
                assert: OP-HEARTBEAT == 1
                logger_.debug "sending heartbeat" --tags={
                  "sequence-number": sequence-number
                }
                websocket_.send "{\"op\": 1, \"d\": $sequence-number}"
              sleep --ms=heartbeat-interval-ms


          should-reconnect = true
          while true:
            data := null
            timeout := 2 * heartbeat-interval-ms or (Duration --m=2).in-ms
            with-timeout --ms=timeout:
              data = websocket_.receive
            if not data:
              logger_.info "null data"
              break

            logger_.debug "received" --tags={ "data": data }
            decoded := json.parse data
            event-sequence-number := decoded.get "s"
            if event-sequence-number:
              sequence-number = event-sequence-number

            if decoded["op"] == OP-INVALID-SESSION:
              if not decoded["d"]:
                // The inner 'd' key is a boolean that indicates whether the session
                // may be resumable.
                session-id = null
                resume-gateway-url = null
              break

            if decoded["op"] == OP-RECONNECT:
              logger_.info "request to reconnect"
              break

            if decoded["op"] == OP-HEARTBEAT-ACK:
              continue

            if decoded["op"] == OP-DISPATCH:
              event := Event.from-json decoded["t"] decoded["d"]

              if event is EventReady:
                ready := event as EventReady
                session-id = ready.session-id
                resume-gateway-url = ready.resume-gateway-url

              // Make sure the unused variables can be garbage collected.
              data = null
              decoded = null
              block.call event

        if exception == DEADLINE-EXCEEDED-ERROR:
          logger_.info "heartbeat timeout"

        if heartbeat-task_:
          heartbeat-task_.cancel
          heartbeat-task_ = null

        block.call EventDisconnected
    finally:
      close

  /** Connects and returns the heartbeat interval. */
  connect_ gateway-url/string intents/int -> int:
    hello := websocket_.receive
    decoded := json.parse hello
    if decoded["op"] != OP-HELLO:
      throw "Expected OP_HELLO, got $decoded"
    heartbeat-interval-ms := decoded["d"]["heartbeat_interval"]

    // Identify.
    identify/Identify? := Identify
        --token=token_
        --intents=intents
        --properties=ConnectionProperties
            --os="linux"
            --browser="Toit"
            --device="TBD"

    payload := json.stringify {
      "op": OP-IDENTIFY,
      "d": identify.to-json
    }
    websocket_.send payload
    return heartbeat-interval-ms

  resume_ session-id/string sequence-number/int -> int:
    resume := Resume
        --token=token_
        --session-id=session-id
        --seq=sequence-number

    payload := json.stringify {
      "op": OP-RESUME,
      "d": resume.to-json
    }
    websocket_.send payload

    hello := websocket_.receive
    decoded := json.parse hello
    if decoded["op"] != OP-HELLO:
      throw "Expected OP_HELLO, got $decoded"
    return decoded["d"]["heartbeat_interval"]

  close --keep-network/bool=false -> none:
    if heartbeat-task_:
      heartbeat-task_.cancel
      heartbeat-task_ = null
    if websocket_:
      websocket_.close
      websocket_ = null
    if network_ and not keep-network:
      network_.close
      network_ = null

class Client:
  token_/string
  my-id_/string? := null
  client_/http.Client? := null
  network_/net.Interface? := null
  gateway_/Gateway? := null
  logger_/log.Logger

  constructor
      --token/string
      --logger/log.Logger=(log.default.with-level log.INFO-LEVEL):
    certificate-roots.install-common-trusted-roots
    token_ = token
    logger_ = logger.with-name "discord"
    network_ = net.open
    client_ = http.Client.tls network_

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
    gateway-response := request_ "/gateway/bot"
    url := gateway-response["url"]
    gateway_ = Gateway --token=token_ --logger=(logger_.with-name "gateway")
    gateway_.connect-and-listen url
        --intents=intents
        block

  send-message message/string --channel-id/string:
    payload := {
      "content": "$message",
      "tts": false,
    }
    request_ "/channels/$channel-id/messages" --payload=payload

  /** Returns the $User object for the bot. */
  me -> User:
    return User.from-json (request_ "/users/@me")

  /** Returns a list of $Guild objects the bot is a member of. */
  guilds -> List:
    json-guilds := request_ "/users/@me/guilds"
    return json-guilds.map: Guild.from-json it

  /** Returns a list of $Channel objects in the given $guild-id. */
  channels guild-id/string -> List:
    channel-list := request_ "/guilds/$guild-id/channels"
    return channel-list.map: Channel.from-json it

  /** Returns the $Channel object for the given $channel-id. */
  channel channel-id/string -> Channel:
    channel-response := request_ "/channels/$channel-id"
    return Channel.from-json channel-response

  /** Returns the $GuildMember with the given $user-id in the given $guild-id. */
  guild-member --guild-id/string --user-id/string -> GuildMember:
    member-response := request_ "/guilds/$guild-id/members/$user-id"
    return GuildMember.from-json member-response

  /** Triggers the typing indicator for the given $channel-id. */
  // TODO(florian): this function doesn't seem to work.
  // I got disconnected when I used it.
  trigger-typing --channel-id/string:
    request_ "/channels/$channel-id/typing" --method=http.POST

  /**
  Returns a list of $Message objects in the given $channel-id.
  If $limit is given, only the last $limit messages are returned.
  */
  messages channel-id/string --limit/int?=null -> List:
    path := "/channels/$channel-id/messages"
    if limit: path = "$path?limit=$limit"
    messages-response := request_ path
    return messages-response.map: Message.from-json it

  request_ -> any
      path/string
      --payload/Map?=null
      --method/string=(payload ? http.POST : http.GET):
    headers := http.Headers
    headers.add "Authorization" "Bot $token_"
    headers.add "User-Agent" "DiscordBot/$BOT-VERSION_ toit-discord"
    response/http.Response? := ?
    if payload:
      response = client_.post-json payload --host=API-HOST_ --path="$API-PATH_/$path" --headers=headers
    else:
      headers.add "Content-Type" "application/json"
      response = client_.get
          API-HOST_
          "$API-PATH_/$path"
          --headers=headers
    if response.status-code != 200:
      throw "HTTP error: $response.status-code"

    decoded := json.decode-stream response.body
    return decoded
