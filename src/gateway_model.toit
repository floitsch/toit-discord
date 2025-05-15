// Copyright (C) 2023 Florian Loitsch.
// Use of this source code is governed by a MIT-style license that can be found
// in the LICENSE file.

import .discord

class Identify:
  /** Authentication token. */
  token/string

  /** Connection properties. */
  properties/ConnectionProperties

  /** Whether this connection supports compression of packets. */
  compress/bool?

  /**
  Total number of members where the gateway will stop sending offline members in
    the guild member list.
  Value between 50 and 250.
  */
  large-threshold/int?

  /**
  Guild sharing information.
  A list of two elements: [shard_id, num_shards]
  */
  shard/List?

  /** Presence structure for initial presence information. */
  presence/UpdatePresence?

  /** Gateway Intents you wish to receive. */
  intents/int

  constructor
      --.token
      --.properties
      --.compress=null
      --.large-threshold=null
      --.shard=null
      --.presence=null
      --.intents=0:

  to-json -> Map:
    result := {
      "token": token,
      "properties": properties.to-json,
      "intents": intents,
    }
    if compress: result["compress"] = compress
    if large-threshold: result["large_threshold"] = large-threshold
    if shard: result["shard"] = shard
    if presence: result["presence"] = presence.to-json
    return result

class Resume:
  /** Session token. */
  token/string

  /** Session id. */
  session-id/string

  /** The last sequence number received. */
  seq/int

  constructor
      --.token
      --.session-id
      --.seq:

  to-json -> Map:
    return {
      "token": token,
      "session_id": session-id,
      "seq": seq,
    }

class ConnectionProperties:
  /** The operating system. */
  os/string

  /** The library name. */
  browser/string

  /** The device name. */
  device/string

  constructor
      --.os
      --.browser
      --.device:

  to-json -> Map:
    return {
      "os": os,
      "browser": browser,
      "device": device,
    }

class UpdatePresence:
  /** Online. */
  static STATUS-ONLINE ::= "online"
  /** Do Not Disturb. */
  static STATUS-DND ::= "dnd"
  /** AFK. */
  static STATUS-IDLE ::= "idle"
  /** Invisible and shown as offline. */
  static STATUS-INVISIBLE ::= "invisible"
  /** Offline. */
  static STATUS-OFFLINE ::= "offline"

  /**
  Time since when the client went idle.
  Null if the client is not idle.
  */
  since/Time?

  /**
  User's new status.
  One of
  */
  status/string

  /** Whether or not the client is afk. */
  afk/bool

  constructor
      --.since=null
      --.status="online"
      --.afk=false:
    // TODO(florian): implement activities.

  to-json -> Map:
    return {
      "since": since.ms-since-epoch,
      "activities": [],
      "status": status,
      "afk": afk,
    }

abstract class Event:
  /** The event type. */
  type/string

  constructor.from-json type/string data/Map:
    if type == "READY":
      return EventReady.from-json type data
    if type == "CHANNEL_CREATE":
      return EventChannelCreate.from-json type data
    if type == "CHANNEL_UPDATE":
      return EventChannelUpdate.from-json type data
    if type == "CHANNEL_DELETE":
      return EventChannelDelete.from-json type data
    if type == "THREAD_CREATE":
      return EventThreadCreate.from-json type data
    if type == "THREAD_UPDATE":
      return EventThreadUpdate.from-json type data
    if type == "THREAD_DELETE":
      return EventThreadDelete.from-json type data
    if type == "EVENT_GUILD_CREATE":
      return EventGuildCreate.from-json type data
    if type == "MESSAGE_CREATE":
      return EventMessageCreate.from-json type data
    if type == "MESSAGE_UPDATE":
      return EventMessageUpdate.from-json type data
    if type == "MESSAGE_DELETE":
      return EventMessageDelete.from-json type data
    if type == "MESSAGE_REACTION_ADD":
      return EventMessageReactionAdd.from-json type data
    if type == "MESSAGE_REACTION_REMOVE":
      return EventMessageReactionRemove.from-json type data
    if type == "MESSAGE_REACTION_REMOVE_ALL":
      return EventMessageReactionRemoveAll.from-json type data
    if type == "TYPING_START":
      return EventTypingStart.from-json type data
    if type == "RESUMED":
      return EventResumed.from-json type data
    return EventOther.from-json type data

  constructor .type:

  stringify -> string:
    return "Event of type $type"

class EventReady extends Event:
  /** API version. */
  v/int

  /** Information about the user including email. */
  user/User

  /**
  Guilds the user is in.
  A list of unavailable $Guild objects (see $Guild.is-available).
  */
  guilds/List

  /**
  The session id.
  Must be provided on future resume attempts.
  */
  session-id/string

  /**
  Gateway URL for resuming connections.
  Must be used to get a new gateway url when attempting to resume.
  */
  resume-gateway-url/string

  /**
  Shard information associated with this session, if sent when identifying.
  A list of two elements: [shard_id, num_shards]
  */
  shard/List?

  /**
  Application information.
  Contains id and flags.
  */
  application/Application

  constructor.from-json type/string data/Map:
    v = data["v"]
    user = User.from-json data["user"]
    guilds = data["guilds"]
    session-id = data["session_id"]
    resume-gateway-url = data["resume_gateway_url"]
    shard = data.get "shard"
    application = Application.from-json data["application"]
    super  type

/**
Sent by this library and not the Discord API, when the client was disconnected.
If the client was able to resume the session, queued events will be sent
  first, followed by an $EventResumed.
If the client was not able to resume the session, an $EventReady is
  sent instead.
*/
class EventDisconnected extends Event:
  constructor:
    super "DISCONNECTED"

  stringify -> string:
    return "EventDisconnected"

/**
Sent when a session was successfully resumed after a disconnect.
This message indicates that all queued events have been sent to the
  client, and all further events are new.
*/
class EventResumed extends Event:
  constructor.from-json type/string data/Map:
    super type

  stringify -> string:
    return "EventResumed"

class EventChannel extends Event:
  /** The channel. */
  channel/Channel

  constructor.from-json type/string data/Map:
    channel = Channel.from-json data
    super type

  stringify -> string:
    return "EventChannel: $channel"

/**
A new guild channel was created.
*/
class EventChannelCreate extends EventChannel:
  constructor.from-json type/string data/Map:
    super.from-json type data

  stringify -> string:
    return "EventChannelCreate: $channel"

/**
A channel was updated.
*/
class EventChannelUpdate extends EventChannel:
  constructor.from-json type/string data/Map:
    super.from-json type data

  stringify -> string:
    return "EventChannelUpdate: $channel"

/**
A channel was deleted.
*/
class EventChannelDelete extends EventChannel:
  constructor.from-json type/string data/Map:
    super.from-json type data

  stringify -> string:
    return "EventChannelDelete: $channel"

class EventThread extends Event:
  /** The thread. */
  channel/Channel

  constructor.from-json type/string data/Map:
    channel = Channel.from-json data
    super type

/**
A new thread was created.

When a thread is created, the $Channel.is-newly-created flag is set to true.
When being added to an existing private thread, then the $Channel.member field
  is not null.
*/
class EventThreadCreate extends EventThread:
  constructor.from-json type/string data/Map:
    super.from-json type data

  stringify -> string:
    return "EventThreadCreate: $channel"

/**
A thread was updated.
This event is not sent for $Channel.last-message-id changes. To keep track of
  the last message in a thread, listen for $EventMessageCreate events.
*/
class EventThreadUpdate extends EventThread:
  constructor.from-json type/string data/Map:
    super.from-json type data

  stringify -> string:
    return "EventThreadUpdate: $channel"

/**
A thread was deleted.

Only a few of the $channel fields are set.
*/
class EventThreadDelete extends EventThread:
  constructor.from-json type/string data/Map:
    super.from-json type data

  stringify -> string:
    return "EventThreadDelete: $channel"

/**
A guild was created.

This event is sent when the bot joins a guild, or
  when an unavailable guild becomes available.
*/
class EventGuildCreate extends Event:
  /** The guild. */
  guild/Guild

  constructor.from-json type/string data/Map:
    guild = Guild.from-json data
    super type

  stringify -> string:
    return "EventGuildCreate: $guild"

class EventMessage extends Event:
  /** The message. */
  message/Message

  constructor.from-json type/string data/Map:
    message = Message.from-json data
    super type

  stringify -> string:
    return "EventMessage - $type: $message"

/**
A message was created.
*/
class EventMessageCreate extends EventMessage:
  constructor.from-json type/string data/Map:
    super.from-json type data

  stringify -> string:
    return "EventMessageCreate: $message"

/**
A message was edited.
*/
class EventMessageUpdate extends EventMessage:
  constructor.from-json type/string data/Map:
    super.from-json type data

  stringify -> string:
    return "EventMessageUpdate: $message"

/**
A message was deleted.
*/
class EventMessageDelete extends EventMessage:
  constructor.from-json type/string data/Map:
    super.from-json type data

  stringify -> string:
    return "EventMessageDelete: $message"

/**
An unknown event.
Used for events that are not yet implemented.
*/
class EventOther extends Event:
  /** The raw data. */
  data/Map

  constructor.from-json type/string .data/Map:
    super type

class EventMessageReaction extends Event:
  constructor type/string:
    super type

/**
A reaction was added to a message.
*/
class EventMessageReactionAdd extends EventMessageReaction:
  /** The user id. */
  user-id/string

  /** The channel id. */
  channel-id/string

  /** The message id. */
  message-id/string

  /** The guild id. */
  guild-id/string?

  /**
  Member who reacted.
  Only present if the reaction is in a guild.
  */
  member/GuildMember?

  /** The emoji. */
  emoji/Emoji

  constructor.from-json type/string data/Map:
    user-id = data["user_id"]
    channel-id = data["channel_id"]
    message-id = data["message_id"]
    guild-id = data.get "guild_id"
    member-entry := data.get "member"
    if member-entry != null:
      member = GuildMember.from-json member-entry
    else:
      member = null
    emoji = Emoji.from-json data["emoji"]
    super type

  stringify -> string:
    return "EventMessageReactionAdd: $user-id reacted with $emoji to $channel-id/$message-id"

/**
A reaction was removed from a message.
*/
class EventMessageReactionRemove extends EventMessageReaction:
  /** The user id. */
  user-id/string

  /** The channel id. */
  channel-id/string

  /** The message id. */
  message-id/string

  /** The guild id. */
  guild-id/string?

  /** The emoji. */
  emoji/Emoji

  constructor.from-json type/string data/Map:
    user-id = data["user_id"]
    channel-id = data["channel_id"]
    message-id = data["message_id"]
    guild-id = data.get "guild_id"
    emoji = Emoji.from-json data["emoji"]
    super type

/**
All reactions from a message were removed.
*/
class EventMessageReactionRemoveAll extends EventMessageReaction:
  /** The channel id. */
  channel-id/string

  /** The message id. */
  message-id/string

  /** The guild id. */
  guild-id/string?

  constructor.from-json type/string data/Map:
    channel-id = data["channel_id"]
    message-id = data["message_id"]
    guild-id = data.get "guild_id"
    super type

/**
A user started typing in a channel.
*/
class EventTypingStart extends Event:
  /** The user id. */
  user-id/string

  /** The channel id. */
  channel-id/string

  /** The timestamp. */
  timestamp-value/int

  /** The guild id. */
  guild-id/string?

  constructor.from-json type/string data/Map:
    user-id = data["user_id"]
    channel-id = data["channel_id"]
    timestamp-value = data["timestamp"]
    guild-id = data.get "guild_id"
    super type

  timestamp -> Time:
    return Time.epoch --s=timestamp-value

  stringify -> string:
    return "EventTypingStart: $user-id started typing in $channel-id"
