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
  large_threshold/int?

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
      --.large_threshold=null
      --.shard=null
      --.presence=null
      --.intents=0:

  to_json -> Map:
    result := {
      "token": token,
      "properties": properties.to_json,
      "intents": intents,
    }
    if compress: result["compress"] = compress
    if large_threshold: result["large_threshold"] = large_threshold
    if shard: result["shard"] = shard
    if presence: result["presence"] = presence.to_json
    return result

class Resume:
  /** Session token. */
  token/string

  /** Session id. */
  session_id/string

  /** The last sequence number received. */
  seq/int

  constructor
      --.token
      --.session_id
      --.seq:

  to_json -> Map:
    return {
      "token": token,
      "session_id": session_id,
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

  to_json -> Map:
    return {
      "os": os,
      "browser": browser,
      "device": device,
    }

class UpdatePresence:
  /** Online. */
  static STATUS_ONLINE ::= "online"
  /** Do Not Disturb. */
  static STATUS_DND ::= "dnd"
  /** AFK. */
  static STATUS_IDLE ::= "idle"
  /** Invisible and shown as offline. */
  static STATUS_INVISIBLE ::= "invisible"
  /** Offline. */
  static STATUS_OFFLINE ::= "offline"

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

  to_json -> Map:
    return {
      "since": since.ms_since_epoch,
      "activities": [],
      "status": status,
      "afk": afk,
    }

abstract class Event:
  /** The event type. */
  type/string

  constructor.from_json type/string data/Map:
    if type == "READY":
      return EventReady.from_json type data
    if type == "CHANNEL_CREATE":
      return EventChannelCreate.from_json type data
    if type == "CHANNEL_UPDATE":
      return EventChannelUpdate.from_json type data
    if type == "CHANNEL_DELETE":
      return EventChannelDelete.from_json type data
    if type == "THREAD_CREATE":
      return EventThreadCreate.from_json type data
    if type == "THREAD_UPDATE":
      return EventThreadUpdate.from_json type data
    if type == "THREAD_DELETE":
      return EventThreadDelete.from_json type data
    if type == "EVENT_GUILD_CREATE":
      return EventGuildCreate.from_json type data
    if type == "MESSAGE_CREATE":
      return EventMessageCreate.from_json type data
    if type == "MESSAGE_UPDATE":
      return EventMessageUpdate.from_json type data
    if type == "MESSAGE_DELETE":
      return EventMessageDelete.from_json type data
    if type == "MESSAGE_REACTION_ADD":
      return EventMessageReactionAdd.from_json type data
    if type == "MESSAGE_REACTION_REMOVE":
      return EventMessageReactionRemove.from_json type data
    if type == "MESSAGE_REACTION_REMOVE_ALL":
      return EventMessageReactionRemoveAll.from_json type data
    if type == "TYPING_START":
      return EventTypingStart.from_json type data
    if type == "RESUMED":
      return EventResumed.from_json type data
    return EventOther.from_json type data

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
  A list of unavailable $Guild objects (see $Guild.is_available).
  */
  guilds/List

  /**
  The session id.
  Must be provided on future resume attempts.
  */
  session_id/string

  /**
  Gateway URL for resuming connections.
  Must be used to get a new gateway url when attempting to resume.
  */
  resume_gateway_url/string

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

  constructor.from_json type/string data/Map:
    v = data["v"]
    user = User.from_json data["user"]
    guilds = data["guilds"]
    session_id = data["session_id"]
    resume_gateway_url = data["resume_gateway_url"]
    shard = data.get "shard"
    application = Application.from_json data["application"]
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
  constructor.from_json type/string data/Map:
    super type

  stringify -> string:
    return "EventResumed"

class EventChannel extends Event:
  /** The channel. */
  channel/Channel

  constructor.from_json type/string data/Map:
    channel = Channel.from_json data
    super type

  stringify -> string:
    return "EventChannel: $channel"

/**
A new guild channel was created.
*/
class EventChannelCreate extends EventChannel:
  constructor.from_json type/string data/Map:
    super.from_json type data

  stringify -> string:
    return "EventChannelCreate: $channel"

/**
A channel was updated.
*/
class EventChannelUpdate extends EventChannel:
  constructor.from_json type/string data/Map:
    super.from_json type data

  stringify -> string:
    return "EventChannelUpdate: $channel"

/**
A channel was deleted.
*/
class EventChannelDelete extends EventChannel:
  constructor.from_json type/string data/Map:
    super.from_json type data

  stringify -> string:
    return "EventChannelDelete: $channel"

class EventThread extends Event:
  /** The thread. */
  channel/Channel

  constructor.from_json type/string data/Map:
    channel = Channel.from_json data
    super type

/**
A new thread was created.

When a thread is created, the $Channel.is_newly_created flag is set to true.
When being added to an existing private thread, then the $Channel.member field
  is not null.
*/
class EventThreadCreate extends EventThread:
  constructor.from_json type/string data/Map:
    super.from_json type data

  stringify -> string:
    return "EventThreadCreate: $channel"

/**
A thread was updated.
This event is not sent for $Channel.last_message_id changes. To keep track of
  the last message in a thread, listen for $EventMessageCreate events.
*/
class EventThreadUpdate extends EventThread:
  constructor.from_json type/string data/Map:
    super.from_json type data

  stringify -> string:
    return "EventThreadUpdate: $channel"

/**
A thread was deleted.

Only a few of the $channel fields are set.
*/
class EventThreadDelete extends EventThread:
  constructor.from_json type/string data/Map:
    super.from_json type data

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

  constructor.from_json type/string data/Map:
    guild = Guild.from_json data
    super type

  stringify -> string:
    return "EventGuildCreate: $guild"

class EventMessage extends Event:
  /** The message. */
  message/Message

  constructor.from_json type/string data/Map:
    message = Message.from_json data
    super type

  stringify -> string:
    return "EventMessage - $type: $message"

/**
A message was created.
*/
class EventMessageCreate extends EventMessage:
  constructor.from_json type/string data/Map:
    super.from_json type data

  stringify -> string:
    return "EventMessageCreate: $message"

/**
A message was edited.
*/
class EventMessageUpdate extends EventMessage:
  constructor.from_json type/string data/Map:
    super.from_json type data

  stringify -> string:
    return "EventMessageUpdate: $message"

/**
A message was deleted.
*/
class EventMessageDelete extends EventMessage:
  constructor.from_json type/string data/Map:
    super.from_json type data

  stringify -> string:
    return "EventMessageDelete: $message"

/**
An unknown event.
Used for events that are not yet implemented.
*/
class EventOther extends Event:
  /** The raw data. */
  data/Map

  constructor.from_json type/string .data/Map:
    super type

class EventMessageReaction extends Event:
  constructor type/string:
    super type

/**
A reaction was added to a message.
*/
class EventMessageReactionAdd extends EventMessageReaction:
  /** The user id. */
  user_id/string

  /** The channel id. */
  channel_id/string

  /** The message id. */
  message_id/string

  /** The guild id. */
  guild_id/string?

  /**
  Member who reacted.
  Only present if the reaction is in a guild.
  */
  member/GuildMember?

  /** The emoji. */
  emoji/Emoji

  constructor.from_json type/string data/Map:
    user_id = data["user_id"]
    channel_id = data["channel_id"]
    message_id = data["message_id"]
    guild_id = data.get "guild_id"
    member_entry := data.get "member"
    if member_entry != null:
      member = GuildMember.from_json member_entry
    else:
      member = null
    emoji = Emoji.from_json data["emoji"]
    super type

  stringify -> string:
    return "EventMessageReactionAdd: $user_id reacted with $emoji to $channel_id/$message_id"

/**
A reaction was removed from a message.
*/
class EventMessageReactionRemove extends EventMessageReaction:
  /** The user id. */
  user_id/string

  /** The channel id. */
  channel_id/string

  /** The message id. */
  message_id/string

  /** The guild id. */
  guild_id/string?

  /** The emoji. */
  emoji/Emoji

  constructor.from_json type/string data/Map:
    user_id = data["user_id"]
    channel_id = data["channel_id"]
    message_id = data["message_id"]
    guild_id = data.get "guild_id"
    emoji = Emoji.from_json data["emoji"]
    super type

/**
All reactions from a message were removed.
*/
class EventMessageReactionRemoveAll extends EventMessageReaction:
  /** The channel id. */
  channel_id/string

  /** The message id. */
  message_id/string

  /** The guild id. */
  guild_id/string?

  constructor.from_json type/string data/Map:
    channel_id = data["channel_id"]
    message_id = data["message_id"]
    guild_id = data.get "guild_id"
    super type

/**
A user started typing in a channel.
*/
class EventTypingStart extends Event:
  /** The user id. */
  user_id/string

  /** The channel id. */
  channel_id/string

  /** The timestamp. */
  timestamp_value/int

  /** The guild id. */
  guild_id/string?

  constructor.from_json type/string data/Map:
    user_id = data["user_id"]
    channel_id = data["channel_id"]
    timestamp_value = data["timestamp"]
    guild_id = data.get "guild_id"
    super type

  timestamp -> Time:
    return Time.epoch --s=timestamp_value

  stringify -> string:
    return "EventTypingStart: $user_id started typing in $channel_id"
