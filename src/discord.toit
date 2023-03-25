// Copyright (C) 2023 Toitware ApS. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be found
// in the LICENSE file.

/*
Discord API: https://discord.com/developers/docs/reference
*/

import certificate_roots
import encoding.json
import http
import net

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

BOT_VERSION ::= "0.1"

API_HOST ::= "discord.com"
API_VERSION ::= "10"
API_PATH ::= "/api/v$API_VERSION"

// https://discord.com/developers/docs/topics/gateway

/**
A gateway is a WebSocket connection to the Discord API.
*/
class Gateway:
  static INTENT_GUILDS ::= 1 << 0
  static INTENT_GUILD_MEMBERS ::= 1 << 1
  static INTENT_GUILD_MODERATION ::= 1 << 2
  static INTENT_GUILD_EMOJIS_AND_STICKERS ::= 1 << 3
  static INTENT_GUILD_INTEGRATIONS ::= 1 << 4
  static INTENT_GUILD_WEBHOOKS ::= 1 << 5
  static INTENT_GUILD_INVITES ::= 1 << 6
  static INTENT_GUILD_VOICE_STATES ::= 1 << 7
  static INTENT_GUILD_PRESENCES ::= 1 << 8
  static INTENT_GUILD_MESSAGES ::= 1 << 9
  static INTENT_GUILD_MESSAGE_REACTIONS ::= 1 << 10
  static INTENT_GUILD_MESSAGE_TYPING ::= 1 << 11
  static INTENT_DIRECT_MESSAGES ::= 1 << 12
  static INTENT_DIRECT_MESSAGE_REACTIONS ::= 1 << 13
  static INTENT_DIRECT_MESSAGE_TYPING ::= 1 << 14
  static INTENT_GUILD_MESSAGE_CONTENT ::= 1 << 15
  static INTENT_GUILD_SCHEDULED_EVENTS ::= 1 << 16
  static INTENT_AUTO_MODERATION_CONFIGURATION ::= 1 << 20
  static INTENT_AUTO_MODERATION_EXECUTION ::= 1 << 21

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

  url/string
  network_/net.Interface? := null
  websocket_/http.WebSocket? := null
  heartbeat_task_/Task? := null
  token_/string

  /**
  Builds a gateway object.

  The $url argument is given by a call to "/gateway/bot" (see $Client.listen_for_notifications).
  Generally, you should not need to call this constructor directly.
  */
  constructor .url --token/string:
    token_ = token

  connect [block]:
    network_ = net.open
    headers := http.Headers
    client := http.Client.tls network_
        --root_certificates=[certificate_roots.BALTIMORE_CYBERTRUST_ROOT]
    url_with_query := "$url/?v=$API_VERSION&encoding=json"
    websocket_ = client.web_socket --uri=url_with_query --headers=headers
    hello := websocket_.receive
    decoded := json.parse hello

    heartbeat_interval_ms := decoded["d"]["heartbeat_interval"]
    jitter := random heartbeat_interval_ms
    heartbeat_task_ = task::
      sleep --ms=jitter
      while true:
        websocket_.send "{\"op\": 1, \"d\": null}".to_byte_array
        sleep --ms=heartbeat_interval_ms

    // Identify.
    intents := 0
      | INTENT_GUILDS
      | INTENT_GUILD_MEMBERS
      | INTENT_GUILD_MESSAGES
      | INTENT_GUILD_MESSAGE_REACTIONS
      | INTENT_GUILD_MESSAGE_TYPING
      | INTENT_DIRECT_MESSAGES
      | INTENT_DIRECT_MESSAGE_REACTIONS
      | INTENT_DIRECT_MESSAGE_TYPING
      | INTENT_GUILD_MESSAGE_CONTENT

    payload := json.stringify {
      "op": OP_IDENTIFY,
      "d": {
        "token": token_,
        "intents": intents,
        "properties": {
          "os": "linux",
          "browser": "Toit",
          "device": "TBD"
        },
      }
    }
    websocket_.send payload

    while data := websocket_.receive:
      block.call (json.parse data)

    // TODO(florian): we got disconnected.
    // For now just close everything down.
    close

  close -> none:
    if heartbeat_task_:
      heartbeat_task_.cancel
      heartbeat_task_ = null
    if network_:
      network_.close
      network_ = null
    if websocket_:
      websocket_.close
      websocket_ = null

class Client:
  token_/string
  my_id_/string? := null
  client_/http.Client? := null
  network_/net.Interface? := null
  gateway_/Gateway? := null

  constructor --token/string:
    token_ = token

  connect -> none:
    network_ = net.open
    client_ = http.Client.tls network_
      --root_certificates=[certificate_roots.BALTIMORE_CYBERTRUST_ROOT]

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

  listen_for_notifications [block]:
    gateway_response := request_ "/gateway/bot"
    url := gateway_response["url"]
    gateway_ = Gateway url --token=token_
    gateway_.connect block

  send_message message/string --channel_id/string:
    payload := {
      "content": "$message",
      "tts": false,
    }
    request_ "/channels/$channel_id/messages" --payload=payload

  me -> Map:
    return request_ "/users/@me"

  guilds -> List:
    return request_ "/users/@me/guilds"

  channels guild_id/string -> List:
    return request_ "/guilds/$guild_id/channels"

  channel channel_id/string -> Map:
    return request_ "/channels/$channel_id"

  messages channel_id/string --limit/int?=null -> List:
    path := "/channels/$channel_id/messages"
    if limit: path = "$path?limit=$limit"
    return request_ path

  request_ -> any
      path/string
      --payload/Map?=null
      --method/string=(payload ? http.POST : http.GET):
    headers := http.Headers
    headers.add "Authorization" "Bot $token_"
    headers.add "User-Agent" "DiscordBot/$BOT_VERSION toit-discord"
    response/http.Response? := ?
    if payload:
      response = client_.post_json payload --host=API_HOST --path="$API_PATH/$path" --headers=headers
    else:
      headers.add "Content-Type" "application/json"
      response = client_.get
          API_HOST
          "$API_PATH/$path"
          --headers=headers
    if response.status_code != 200:
      throw "HTTP error: $response.status_code"

    decoded := json.decode_stream response.body
    // print (json.stringify decoded)
    return decoded
