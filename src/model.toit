// Copyright (C) 2023 Florian Loitsch.
// Use of this source code is governed by a MIT-style license that can be found
// in the LICENSE file.

import .discord

class UserFlags:
  /** A discord employee. */
  static STAFF ::= 1 << 0
  /** A partnered server owner. */
  static PARTNER ::= 1 << 1
  /** A hypesquad events participant. */
  static HYPESQUAD ::= 1 << 2
  /** A bug hunter level 1. */
  static BUG-HUNTER-LEVEL-1 ::= 1 << 3
  /** A house bravery member. */
  static HOUSE-BRAVERY ::= 1 << 6
  /** A house brilliance member. */
  static HOUSE-BRILLIANCE ::= 1 << 7
  /** A house balance member. */
  static HOUSE-BALANCE ::= 1 << 8
  /** A early Nitro supporter. */
  static EARLY-SUPPORTER ::= 1 << 9
  /** A team user. */
  static TEAM-PSEUDO-USER ::= 1 << 10
  /** A bug hunter level 2. */
  static BUG-HUNTER-LEVEL-2 ::= 1 << 14
  /** A verified bot. */
  static VERIFIED-BOT ::= 1 << 16
  /** A verified bot developer. */
  static VERIFIED-DEVELOPER ::= 1 << 17
  /** Moderator Programs Alumni. */
  static USER-CERTIFIED-MODERATOR ::= 1 << 18
  /** Flag that the bot only uses HTTP interactions and is shown in the online member list. */
  static USER-BOT-HTTP-INTERACTIONS ::= 1 << 19
  /** An active developer. */
  static USER-ACTIVE-DEVELOPER ::= 1 << 22

  value/int

  constructor .value:

  /** Whether the user is a discord employee. */
  is-staff -> bool: return (value & STAFF) != 0
  /** Whether the user is a partnered server owner. */
  is-partner -> bool: return (value & PARTNER) != 0
  /** Whether the user is a hypesquad events participant. */
  is-hypesquad -> bool: return (value & HYPESQUAD) != 0
  /** Whether the user is a bug hunter level 1. */
  is-bug-hunter-level-1 -> bool: return (value & BUG-HUNTER-LEVEL-1) != 0
  /** Whether the user is a house bravery member. */
  is-house-bravery -> bool: return (value & HOUSE-BRAVERY) != 0
  /** Whether the user is a house brilliance member. */
  is-house-brilliance -> bool: return (value & HOUSE-BRILLIANCE) != 0
  /** Whether the user is a house balance member. */
  is-house-balance -> bool: return (value & HOUSE-BALANCE) != 0
  /** Whether the user is a early Nitro supporter. */
  is-early-supporter -> bool: return (value & EARLY-SUPPORTER) != 0
  /** Whether the user is a team user. */
  is-team-pseudo-user -> bool: return (value & TEAM-PSEUDO-USER) != 0
  /** Whether the user is a bug hunter level 2. */
  is-bug-hunter-level-2 -> bool: return (value & BUG-HUNTER-LEVEL-2) != 0
  /** Whether the user is a verified bot. */
  is-verified-bot -> bool: return (value & VERIFIED-BOT) != 0
  /** Whether the user is a verified bot developer. */
  is-verified-developer -> bool: return (value & VERIFIED-DEVELOPER) != 0
  /** Whether the user is a moderator programs alumni. */
  is-user-certified-moderator -> bool: return (value & USER-CERTIFIED-MODERATOR) != 0
  /** Whether the bot only uses HTTP interactions and is shown in the online member list. */
  is-user-bot-http-interactions -> bool: return (value & USER-BOT-HTTP-INTERACTIONS) != 0
  /** Whether the user is an active developer. */
  is-user-active-developer -> bool: return (value & USER-ACTIVE-DEVELOPER) != 0

  stringify -> string:
    result := "Flags ($value)"
    flag-strings := []
    if is-staff: flag-strings.add "discord employee"
    if is-partner: flag-strings.add "partnered server owner"
    if is-hypesquad: flag-strings.add "hypesquad events participant"
    if is-bug-hunter-level-1: flag-strings.add "bug hunter level 1"
    if is-house-bravery: flag-strings.add "house bravery member"
    if is-house-brilliance: flag-strings.add "house brilliance member"
    if is-house-balance: flag-strings.add "house balance member"
    if is-early-supporter: flag-strings.add "early Nitro supporter"
    if is-team-pseudo-user: flag-strings.add "team user"
    if is-bug-hunter-level-2: flag-strings.add "bug hunter level 2"
    if is-verified-bot: flag-strings.add "verified bot"
    if is-verified-developer: flag-strings.add "verified bot developer"
    if is-user-certified-moderator: flag-strings.add "moderator programs alumni"
    if is-user-bot-http-interactions: flag-strings.add "bot only uses HTTP interactions"
    if is-user-active-developer: flag-strings.add "active developer"
    if flag-strings.is-empty: return result
    return "$result: $(flag-strings.join ", ")"

class PremiumType:
  /** None. */
  static NONE ::= 0
  /** Nitro Classic. */
  static NITRO-CLASSIC ::= 1
  /** Nitro. */
  static NITRO ::= 2
  /** Nitro Basic. */
  static NITRO-BASIC ::= 3

  value/int

  constructor .value:

  stringify -> string:
    if value == NONE: return "None"
    if value == NITRO-CLASSIC: return "Nitro Classic"
    if value == NITRO: return "Nitro"
    if value == NITRO-BASIC: return "Nitro Basic"
    return "Unknown ($value)"

interface Author:
  /** The id of the author. */
  id -> string

  /** The username of the author. */
  username -> string

  /** The user's avatar hash. */
  avatar -> string?

class User implements Author:
  /**
  The user's id.
  A snowflake.
  */
  id/string

  /**
  The user's username.
  This is not unique across the Discord platform.
  */
  username/string

  /** The user's 4-digit discord-tag. */
  discriminator/string

  /** The user's avatar hash. */
  avatar/string?

  /** Whether the user belongs to an OAuth2 application. */
  is-bot/bool?

  /** Whether the user is an Official Discord System user (part of the urgent message system). */
  is-system/bool?

  /** Whether the user has two factor enabled on their account. */
  is-mfa-enabled/bool?

  /** The user's banner hash. */
  banner/string?

  /**
  The user's accent color.
  The color is encoded as an integer representation of hexadecimal color code.
  */
  accent-color/int?

  /** The user's chosen language option. */
  locale/string?

  /** Whether the email on this account has been verified. */
  is-verified/bool?

  /** The user's email. */
  email/string?

  /** The flags on a user's account. */
  flags-value/int?

  /** The type of Nitro subscription on a user's account. */
  premium-type/int?

  /** The public flags on a user's account. */
  public-flags-value/int?

  constructor.from-json json/Map:
    id = json["id"]
    username = json["username"]
    discriminator = json["discriminator"]
    avatar = json.get "avatar"
    is-bot = json.get "bot"
    is-system = json.get "system"
    is-mfa-enabled = json.get "mfa_enabled"
    banner = json.get "banner"
    accent-color = json.get "accent_color"
    locale = json.get "locale"
    is-verified = json.get "verified"
    email = json.get "email"
    flags-value = json.get "flags"
    premium-type = json.get "premium_type"
    public-flags-value = json.get "public_flags"

  /** The flags on a user's account. */
  flags -> UserFlags?:
    return flags-value and UserFlags flags-value

  /** The public flags on a user's account. */
  public-flags -> UserFlags?:
    return public-flags-value and UserFlags public-flags-value

  stringify -> string:
    return "User<id: $id, username: $username, discriminator: $discriminator>"

class SystemChannelFlags:
  /** Suppress member join notifications. */
  static SUPPRESS-JOIN-NOTIFICATIONS ::= 1 << 0
  /** Suppress server boost notifications. */
  static SUPPRESS-PREMIUM-SUBSCRIPTIONS ::= 1 << 1
  /** Suppress server setup tips. */
  static SUPPRESS-GUILD-REMINDER-NOTIFICATIONS ::= 1 << 2
  /** Hide member join sticker reply buttons. */
  static SUPPRESS-JOIN-NOTIFICATIONS-REPLIES ::= 1 << 3
  /** Suppress role subscription purchase and renewal notifications. */
  static SUPPRESS-ROLE-SUBSCRIPTION-PURCHASE-NOTIFICATIONS ::= 1 << 4
  /** Hide role subscription sticker reply buttons. */
  static SUPPRESS-ROLE-SUBSCRIPTION-PURCHASE-NOTIFICATION-REPLIES ::= 1 << 5

  value/int

  constructor .value:

  /** Whether member join notifications are suppressed. */
  suppresses-join-notifications -> bool:
    return (value & SUPPRESS-JOIN-NOTIFICATIONS) != 0

  /** Whether server boost notifications are suppressed. */
  suppresses-premium-subscriptions -> bool:
    return (value & SUPPRESS-PREMIUM-SUBSCRIPTIONS) != 0

  /** Whether server setup tips are suppressed. */
  suppresses-guild-reminder-notifications -> bool:
    return (value & SUPPRESS-GUILD-REMINDER-NOTIFICATIONS) != 0

  /** Whether member join sticker reply buttons are hidden. */
  suppresses-join-notifications-replies -> bool:
    return (value & SUPPRESS-JOIN-NOTIFICATIONS-REPLIES) != 0

  /** Whether role subscription purchase and renewal notifications are suppressed. */
  suppresses-role-subscription-purchase-notifications -> bool:
    return (value & SUPPRESS-ROLE-SUBSCRIPTION-PURCHASE-NOTIFICATIONS) != 0

  /** Whether role subscription sticker reply buttons are hidden. */
  suppresses-role-subscription-purchase-notification-replies -> bool:
    return (value & SUPPRESS-ROLE-SUBSCRIPTION-PURCHASE-NOTIFICATION-REPLIES) != 0

class Guild:
  /** Members receive notifications for all messages by default. */
  static DEFAULT-MESSAGE-NOTIFICATIONS-ALL-MESSAGES ::= 0
  /** Members receive notifications only for messages that @mention them. */
  static DEFAULT-MESSAGE-NOTIFICATIONS-ONLY-MENTIONS ::= 1

  /** Media content is not scanned. */
  static EXPLICIT-CONTENT-FILTER-DISABLED ::= 0
  /** Media content sent by members without a role is scanned. */
  static EXPLICIT-CONTENT-FILTER-MEMBERS-WITHOUT-ROLES ::= 1
  /** Media content sent by all members is scanned. */
  static EXPLICIT-CONTENT-FILTER-ALL-MEMBERS ::= 2

  /** The guild has no MFA/2FA requirement for moderation actions. */
  static MFA-LEVEL-NONE ::= 0
  /** The guild has a 2FA requirement for moderation actions. */
  static MFA-LEVEL-ELEVATED ::= 1

  /** Unrestricted. */
  static VERIFICATION-LEVEL-NONE ::= 0
  /** Must have a verified email on their account. */
  static VERIFICATION-LEVEL-LOW ::= 1
  /** Must be registered on Discord for longer than 5 minutes. */
  static VERIFICATION-LEVEL-MEDIUM ::= 2
  /** Must be a member of the server for longer than 10 minutes. */
  static VERIFICATION-LEVEL-HIGH ::= 3
  /** Must have a verified phone number. */
  static VERIFICATION-LEVEL-VERY-HIGH ::= 4

  static NSFW-LEVEL-DEFAULT ::= 0
  static NSFW-LEVEL-EXPLICIT ::= 1
  static NSFW-LEVEL-SAFE ::= 2
  static NSFW-LEVEL-AGE-RESTRICTED ::= 3

  /** The guild has not unlocked any server boost perks. */
  static PREMIUM-TIER-NONE ::= 0
  /** The guild has unlocked server boost level 1 perks. */
  static PREMIUM-TIER-1 ::= 1
  /** The guild has unlocked server boost level 2 perks. */
  static PREMIUM-TIER-2 ::= 2
  /** The guild has unlocked server boost level 3 perks. */
  static PREMIUM-TIER-3 ::= 3

  /**
  The guild's id.
  A snowflake.
  */
  id/string

  /** The guild's name. */
  name/string?

  /** The guild's icon hash. */
  icon/string?

  /**
  The guild's icon hash.
  Returned when in the template object.
  */
  icon-hash/string?

  /** The guild's splash hash. */
  splash/string?

  /** The guild's discovery splash hash. */
  discovery-splash/string?

  /** Whether the user is the owner of the guild. */
  is-owner/bool?

  /** The id of the guild owner. */
  owner-id/string?

  /** The total permissions for the user in the guild (excludes overwrites). */
  permissions/string?

  /** The voice region id for the guild. */
  region/string?

  /** The id of the afk channel. */
  afk-channel-id/string?

  /** The afk timeout in seconds. */
  afk-timeout/int?

  /** Whether the server widget is enabled. */
  is-widget-enabled/bool?

  /** The id of the channel where the server widget will generate an invite to. */
  widget-channel-id/string?

  /**
  The verification level required for the guild.
  One of:
  - $VERIFICATION-LEVEL-NONE
  - $VERIFICATION-LEVEL-LOW
  - $VERIFICATION-LEVEL-MEDIUM
  - $VERIFICATION-LEVEL-HIGH
  - $VERIFICATION-LEVEL-VERY-HIGH
  */
  verification-level/int?

  /**
  The default message notifications level.
  Either $DEFAULT-MESSAGE-NOTIFICATIONS-ALL-MESSAGES or $DEFAULT-MESSAGE-NOTIFICATIONS-ONLY-MENTIONS.
  */
  default-message-notifications/int?

  /**
  The explicit content filter level.
  One of:
  - $EXPLICIT-CONTENT-FILTER-DISABLED
  - $EXPLICIT-CONTENT-FILTER-MEMBERS-WITHOUT-ROLES
  - $EXPLICIT-CONTENT-FILTER-ALL-MEMBERS
  */
  explicit-content-filter/int?

  /**
  The roles in the guild.
  A list of $Role objects.
  */
  roles/List?

  /**
  The custom guild emojis.
  A list of $Emoji objects.
  */
  emojis/List?

  /**
  The enabled guild features.
  A list of guild feature strings.
  See https://discord.com/developers/docs/resources/guild#guild-object-guild-features for more information.
  */
  features/List?

  /**
  The required MFA level for the guild.
  Either $MFA-LEVEL-NONE or $MFA-LEVEL-ELEVATED.
  */
  mfa-level/int?

  /** The id of the application that created the guild. */
  application-id/string?

  /** The id of the channel where guild notices such as welcome messages and boost events are posted. */
  system-channel-id/string?

  /** The system channel flags. */
  system-channel-flags-value/int?

  /** The id of the channel where Community guilds can display rules and/or guidelines. */
  rules-channel-id/string?

  /**
  The maximum number of presences for the guild.
  Null is always returned, apart from the largest of guilds.
  */
  max-presences/int?

  /** The maximum number of members for the guild. */
  max-members/int?

  /** The vanity url code for the guild. */
  vanity-url-code/string?

  /** The description of the guild. */
  description/string?

  /** The banner hash. */
  banner/string?

  /**
  The premium tier (Server Boost level).
  One of:
  - $PREMIUM-TIER-NONE
  - $PREMIUM-TIER-1
  - $PREMIUM-TIER-2
  - $PREMIUM-TIER-3
  */
  premium-tier/int?

  /** The number of boosts this guild currently has. */
  premium-subscription-count/int?

  /** The preferred locale of a Community guild; used in server discovery and notices from Discord, and sent in interactions; defaults to "en-US".
  */
  preferred-locale/string?

  /** The id of the channel where admins and moderators of Community guilds receive notices from Discord. */
  public-updates-channel-id/string?

  /**
  The maximum amount of users in a video channel.
  Returned when in the template object.
  */
  max-video-channel-users/int?

  /**
  Approximate number of members in this guild.
  Returned from the GET /guilds/<id> endpoint when with_counts is true.
  */
  approximate-member-count/int?

  /**
  Approximate number of non-offline members in this guild.
  Returned from the GET /guilds/<id> endpoint when with_counts is true.
  */
  approximate-presence-count/int?

  /** The welcome screen of a Community guild, shown to new members, returned in an Invite's guild object. */
  welcome-screen/WelcomeScreen?

  /**
  The guild NSFW level.
  One of:
  - $NSFW-LEVEL-DEFAULT
  - $NSFW-LEVEL-EXPLICIT
  - $NSFW-LEVEL-SAFE
  - $NSFW-LEVEL-AGE-RESTRICTED
  */
  nsfw-level/int?

  /**
  The custom guild stickers.
  A list of $Sticker objects.
  */
  stickers/List?

  /** Whether the guild has the boost progress bar enabled. */
  premium-progress-bar-enabled/bool?

  /**
  Whether this guild is available.
  A partial guild, or unavailable guild, is a guild whose information
    has not been provided.
  Unavailable guilds only have their $id set.
  */
  is-available/bool

  constructor.from-json json/Map:
    is-available = not json.contains "unavailable"
    id = json["id"]
    name = json.get "name"
    icon = json.get "icon"
    icon-hash = json.get "icon_hash"
    splash = json.get "splash"
    discovery-splash = json.get "discovery_splash"
    is-owner = json.get "owner"
    owner-id = json.get "owner_id"
    permissions = json.get "permissions"
    region = json.get "region"
    afk-channel-id = json.get "afk_channel_id"
    afk-timeout = json.get "afk_timeout"
    is-widget-enabled = json.get "widget_enabled"
    widget-channel-id = json.get "widget_channel_id"
    verification-level = json.get "verification_level"
    default-message-notifications = json.get "default_message_notifications"
    explicit-content-filter = json.get "explicit_content_filter"
    roles = json.get "roles"
    emojis = json.get "emojis"
    features = json.get "features"
    mfa-level = json.get "mfa_level"
    application-id = json.get "application_id"
    system-channel-id = json.get "system_channel_id"
    system-channel-flags-value = json.get "system_channel_flags"
    rules-channel-id = json.get "rules_channel_id"
    max-presences = json.get "max_presences"
    max-members = json.get "max_members"
    vanity-url-code = json.get "vanity_url_code"
    description = json.get "description"
    banner = json.get "banner"
    premium-tier = json.get "premium_tier"
    premium-subscription-count = json.get "premium_subscription_count"
    preferred-locale = json.get "preferred_locale"
    public-updates-channel-id = json.get "public_updates_channel_id"
    max-video-channel-users = json.get "max_video_channel_users"
    approximate-member-count = json.get "approximate_member_count"
    approximate-presence-count = json.get "approximate_presence_count"
    welcome-screen-entry := json.get "welcome_screen"
    if welcome-screen-entry:
      welcome-screen = WelcomeScreen.from-json welcome-screen-entry
    else:
      welcome-screen = null
    nsfw-level = json.get "nsfw_level"
    stickers-entry := json.get "stickers"
    if stickers-entry:
      stickers = stickers-entry.map: Sticker.from-json it
    else:
      stickers = []
    premium-progress-bar-enabled = json.get "premium_progress_bar_enabled"

  system-channel-flags -> SystemChannelFlags:
    return SystemChannelFlags system-channel-flags-value

class Role:
  /** The role's id. */
  id/string

  /** The role's name. */
  name/string

  /** The role's color. */
  color/int

  /** Whether the role is hoisted. */
  is-hoisted/bool

  /** The role's icon hash. */
  icon/string?

  /** The role's unicode emoji. */
  unicode-emoji/string?

  /** The role's position. */
  position/int

  /** The role's permissions. */
  permissions/string

  /** Whether the role is managed. */
  is-managed/bool

  /** Whether the role is mentionable. */
  is-mentionable/bool

  /** The role's tags. */
  tags/RoleTags?

  constructor.from-json json/Map:
    id = json["id"]
    name = json["name"]
    color = json["color"]
    is-hoisted = json["hoist"]
    icon = json.get "icon"
    unicode-emoji = json.get "unicode_emoji"
    position = json["position"]
    permissions = json["permissions"]
    is-managed = json["managed"]
    is-mentionable = json["mentionable"]
    tags-json := json.get "tags"
    if tags-json:
      tags = RoleTags.from-json tags-json
    else:
      tags = null

class RoleTags:
  /** The id of the bot this role belongs to. */
  bot-id/string?

  /** The id of the integration this role belongs to. */
  integration-id/string?

  /** Whether this is the guild's Booster role. */
  is-premium-subscriber/bool?

  /** The id of this role's subscription sku and listing. */
  subscription-listing-id/string?

  /** Whether this role is available for purchase. */
  is-available-for-purchase/bool?

  /** Whether this role is a guild's linked role. */
  is-guild-connections/bool?

  constructor.from-json json/Map:
    bot-id = json.get "bot_id"
    integration-id = json.get "integration_id"
    is-premium-subscriber = json.get "premium_subscriber"
    subscription-listing-id = json.get "subscription_listing_id"
    is-available-for-purchase = json.get "available_for_purchase"
    is-guild-connections = json.get "guild_connections"

class Emoji:
  /** The emoji's id. */
  id/string?

  /** The emoji's name. */
  name/string?

  /**
  The roles allowed to use this emoji.
  List of $Role objects.
  */
  roles/List?

  /** The user that created this emoji. */
  user/User?

  /** Whether this emoji must be wrapped in colons. */
  requires-colons/bool?

  /** Whether this emoji is managed. */
  is-managed/bool?

  /** Whether this emoji is animated. */
  is-animated/bool?

  /**
  Whether this emoji can be used.
  May be false due to loss of Server Boosts.
  */
  is-available/bool?

  constructor.from-json json/Map:
    id = json.get "id"
    name = json.get "name"
    roles = json.get "roles"
    user-entry := json.get "user"
    if user-entry:
      user = User.from-json user-entry
    else:
      user = null
    requires-colons = json.get "require_colons"
    is-managed = json.get "managed"
    is-animated = json.get "animated"
    is-available = json.get "available"

  stringify -> string:
    return "Emoji $name"

class WelcomeScreen:
  /** The server description shown in the welcome screen. */
  description/string?

  /**
  The channels shown in the welcome screen, up to 5.
  A list of $WelcomeScreenChannel objects.
  */
  welcome-channels/List

  constructor.from-json json/Map:
    description = json.get "description"
    welcome-channels = json["welcome_channels"].map: WelcomeScreenChannel.from-json it

class WelcomeScreenChannel:
  /** The channel's id. */
  channel-id/string

  /** The description shown for the channel. */
  description/string

  /** The emoji id, if the emoji is custom. */
  emoji-id/string?

  /** The emoji name if custom, the unicode character if standard, or null if no emoji is set. */
  emoji-name/string?

  constructor.from-json json/Map:
    channel-id = json["channel_id"]
    description = json["description"]
    emoji-id = json.get "emoji_id"
    emoji-name = json.get "emoji_name"

class Sticker:
  /**
  An official sticker in a pack.
  Part of Nitro or in a removed purchasable pack.
  */
  static TYPE-STANDARD ::= 1
  /** A sticker uploaded to a guild for the guild's members. */
  static TYPE-GUILD ::= 2

  /** A PNG sticker. */
  static FORMAT-TYPE-PNG ::= 1
  /** An APNG (animated PNG) sticker. */
  static FORMAT-TYPE-APNG ::= 2
  /** A Lottie (vector graphics animation) sticker. */
  static FORMAT-TYPE-LOTTIE ::= 3
  /** A GIF sticker. */
  static FORMAT-TYPE-GIF ::= 4

  /** The sticker's id. */
  id/string

  /** The id of the pack the sticker is from. */
  pack-id/string?

  /** The sticker's name. */
  name/string

  /** The sticker's description. */
  description/string?

  /**
  The sticker's tags.
  Autocomplete/suggestion tags for the sticker (max 200 characters).
  Standard tickers use a comma-separated list of keywords as format. This is
    just a convention. Incidentally the client will always use a
    name generated from an emoji as the value of this field when creating
    or modifying a guild sticker.
  */
  tags/string

  /** The sticker's asset hash. */
  asset/string?

  /**
  The sticker's type.

  Either $TYPE-STANDARD or $TYPE-GUILD.
  */
  type/int

  /**
  The sticker's format type.
  One of:
  - $FORMAT-TYPE-PNG
  - $FORMAT-TYPE-APNG
  - $FORMAT-TYPE-LOTTIE
  - $FORMAT-TYPE-GIF
  */
  format-type/int

  /**
  Whether this guild sticker can be used.
  May be false due to loss of Server Boosts.
  */
  is-available/bool?

  /** The id of the guild that owns this sticker. */
  guild-id/string?

  /** The user that uploaded the guild sticker. */
  user/User?

  /** The standard sticker's sort order within its pack. */
  sort-value/int?

  constructor.from-json json/Map:
    id = json["id"]
    pack-id = json.get "pack_id"
    name = json["name"]
    description = json.get "description"
    tags = json["tags"]
    asset = json.get "asset"
    type = json["type"]
    format-type = json["format_type"]
    is-available = json.get "available"
    guild-id = json.get "guild_id"
    user = json.get "user"
    sort-value = json.get "sort_value"

class Channel:
  /** A text channel within a server. */
  static TYPE-GUILD-TEXT ::= 0
  /** A direct message between users. */
  static TYPE-DM ::= 1
  /** A voice channel within a server. */
  static TYPE-GUILD-VOICE ::= 2
  /** A direct message between multiple users. */
  static TYPE-GROUP-DM ::= 3
  /** An organizational category that contains up to 50 channels. */
  static TYPE-GUILD-CATEGORY ::= 4
  /** A channel that users can follow and crosspost into their own server. */
  static TYPE-GUILD-ANNOUNCEMENT ::= 5
  /** A temporary sub-channel within a GUILD_ANNOUNCEMENT channel. */
  static TYPE-ANNOUNCEMENT-THREAD ::= 10
  /** A temporary sub-channel within a GUILD_TEXT or GUILD_FORUM channel. */
  static TYPE-PUBLIC-THREAD ::= 11
  /** A temporary sub-channel within a GUILD_TEXT channel that is only viewable by those invited and those with the MANAGE_THREADS permission. */
  static TYPE-PRIVATE-THREAD ::= 12
  /** A voice channel for hosting events with an audience. */
  static TYPE-GUILD-STAGE-VOICE ::= 13
  /** The channel in a hub containing the listed servers. */
  static TYPE-GUILD-DIRECTORY ::= 14
  /** Channel that can only contain threads. */
  static TYPE-GUILD-FORUM ::= 15

  /** Discord chooses the quality for optimal performance. */
  static VIDEO-QUALITY-MODE-AUTO ::= 1
  /** 720p. */
  static VIDEO-QUALITY-MODE-FULL ::= 2

  /** Sort forum posts by activity. */
  static SORT-ORDER-LATEST-ACTIVITY ::= 0
  /** Sort forum posts by creation date (from most recent to oldest). */
  static SORT-ORDER-CREATION-DATE ::= 1

  /** No default has been set for the form channel. */
  static LAYOUT-NOT-SET ::= 0
  /** Display posts as a list. */
  static LAYOUT-LIST-VIEW ::= 1
  /** Display posts as a collection of tiles. */
  static LAYOUT-GALLERY-VIEW ::= 2

  /** The id of this channel. */
  id/string

  /**
  The type of channel.
  One of:
  - $TYPE-GUILD-TEXT
  - $TYPE-DM
  - $TYPE-GUILD-VOICE
  - $TYPE-GROUP-DM
  - $TYPE-GUILD-CATEGORY
  - $TYPE-GUILD-ANNOUNCEMENT
  - $TYPE-ANNOUNCEMENT-THREAD
  - $TYPE-PUBLIC-THREAD
  - $TYPE-PRIVATE-THREAD
  - $TYPE-GUILD-STAGE-VOICE
  - $TYPE-GUILD-DIRECTORY
  - $TYPE-GUILD-FORUM
  */
  type/int

  /**
  The id of the guild.
  May be missing for some channel objects received over gateway guild dispatches).
  */
  guild-id/string?

  /** Sorting position of the channel. */
  position/int?

  /**
  Explicit permission overwrites for members and roles.
  List of $Overwrite objects.
  */
  permission-overwrites/List?

  /**
  The name of the channel.
  The name is 1-100 characters long.
  */
  name/string?

  /**
  The channel topic.
  The name is 0-4096 characters long for GUILD_FORUM channels;
    0-1024 characters for all others.
  */
  topic/string?

  /** Whether the channel is nsfw. */
  is-nsfw/bool?

  /**
  The id of the last message sent in this channel (or thread for GUILD_FORUM channels).
  May not point to an existing or valid message or thread.
  */
  last-message-id/string?

  /** The bitrate (in bits) of the voice channel. */
  bitrate/int?

  /** The user limit of the voice channel. */
  user-limit/int?

  /**
  Amount of seconds a user has to wait before sending another message.
  The value is in range 0-21600.
  Bots, as well as users with the permission manage_messages or manage_channel,
    are unaffected.
  */
  rate-limit-per-user/int?

  /**
  The recipients of the DM.
  A list of $User.
  */
  recipients/List?

  /** Icon hash of the group DM. */
  icon/string?

  /** Id of the creator of the group DM or thread. */
  owner-id/string?

  /** Application id of the group DM creator if it is bot-created. */
  application-id/string?

  /**
  Whether the channel is managed by an application via the gdm.join OAuth2 scope.
  Only for group DM channels.
  */
  is-managed/bool?

  /**
  The id of the parent category for a channelor (for guild channels), or
    the id of the text channel thing this thread was created (for threads).
  Each parent category can contain up to 50 channels.
  */
  parent-id/string?

  /**
  When the last pinned message was pinned.
  This may be null in events such as GUILD_CREATE when a message is not pinned.
  */
  last-pin-timestamp/string?

  /** Voice region id for the voice channel, automatic when set to null. */
  rtc-region/string?

  /**
  The camera video quality mode of the voice channel.
  If not present: $VIDEO-QUALITY-MODE-AUTO.

  One of:
  - $VIDEO-QUALITY-MODE-AUTO
  - $VIDEO-QUALITY-MODE-FULL
  */
  video-quality-mode/int?

  /**
  Number of messages in a thread.
  Does not include the initial message or deleted messages.
  */
  message-count/int?

  /**
  An approximate count of users in a thread.
  Stops counting at 50.
  */
  member-count/int?

  /** Thread-specific fields not needed by other channels. */
  thread-metadata/ThreadMetadata?

  /**
  Thread member object for the current user, if they have joined the thread.
  Only included on certain API endpoints.
  */
  member/ThreadMember?

  /**
  Default duration in minutes after which the thread is automatically archived.
  Copied onto newly created threads.
  Threads stop showing in the channel list after the specified period of inactivity.
  Can be set to: 60, 1440, 4320, 10080.
  */
  default-auto-archive-duration/int?

  /**
  Computed permissions for the invoking user in the channel, including overwrites.
  Only included when part of the resolved data received on a slash command interaction.
  */
  permissions/string?

  /** Channel flags combined as a bitfield. */
  flags-value/int?

  /**
  The total number of messages sent in this thread.
  Similar to $message-count, but does not decrease when a message is deleted.
  */
  total-message-sent/int?

  /** The set of tags that can be used in a GUILD_FORUM channel. */
  available-tags/List?

  /**
  The IDs of the set of tags that have been applied to a thread in a GUILD_FORUM channel.
  */
  applied-tags/List?

  /**
  The emoji to show in the add reaction button on a thread in a GUILD_FORUM channel.
  */
  default-reaction/DefaultReaction?

  /**
  The initial rate_limit_per_user to set on newly created threads in a channel.
  This field is copied to the thread at creation time and does not live update.
  */
  default-thread-rate-limit-per-user/int?

  /**
  The default sort order type used to order posts in GUILD_FORUM channels.
  Defaults to null, which indicates a preferred sort order hasn't been set by a channel admin.
  One of $SORT-ORDER-LATEST-ACTIVITY or $SORT-ORDER-CREATION-DATE.
  */
  default-sort-order/int?

  /**
  The default forum layout view used to display posts in GUILD_FORUM channels.
  Defaults to $LAYOUT-NOT-SET, which indicates a layout view has
    not been set by a channel admin.
  One of:
  - $LAYOUT-NOT-SET
  - $LAYOUT-LIST-VIEW
  - $LAYOUT-GALLERY-VIEW
  */
  default-forum-layout/int?

  /**
  Set when the channel is created.
  Only used for events.
  */
  is-newly-created/bool?

  constructor.from-json json/Map:
    id = json["id"]
    type = json["type"]
    guild-id = json.get "guild_id"
    position = json.get "position"
    permission-overwrites-entry := json.get "permission_overwrites"
    if permission-overwrites-entry:
      permission-overwrites = permission-overwrites-entry.map: Overwrite.from-json it
    else:
      permission-overwrites = null
    name = json.get "name"
    topic = json.get "topic"
    is-nsfw = json.get "nsfw"
    last-message-id = json.get "last_message_id"
    bitrate = json.get "bitrate"
    user-limit = json.get "user_limit"
    rate-limit-per-user = json.get "rate_limit_per_user"
    recipients-entry := json.get "recipients"
    if recipients-entry:
      recipients = recipients-entry.map: User.from-json it
    else:
      recipients = null
    icon = json.get "icon"
    owner-id = json.get "owner_id"
    application-id = json.get "application_id"
    is-managed = json.get "is_managed"
    parent-id = json.get "parent_id"
    last-pin-timestamp = json.get "last_pin_timestamp"
    rtc-region = json.get "rtc_region"
    video-quality-mode = json.get "video_quality_mode"
    message-count = json.get "message_count"
    member-count = json.get "member_count"
    thread-metadata-entry := json.get "thread_metadata"
    if thread-metadata-entry:
      thread-metadata = ThreadMetadata.from-json thread-metadata-entry
    else:
      thread-metadata = null
    member-entry := json.get "member"
    if member-entry:
      member = ThreadMember.from-json member-entry
    else:
      member = null
    default-auto-archive-duration = json.get "default_auto_archive_duration"
    permissions = json.get "permissions"
    flags-value = json.get "flags"
    total-message-sent = json.get "total_message_sent"
    available-tags = json.get "available_tags"
    applied-tags = json.get "applied_tags"
    default-reaction-entry := json.get "default_reaction_emoji"
    if default-reaction-entry:
      default-reaction = DefaultReaction.from-json default-reaction-entry
    else:
      default-reaction = null
    default-thread-rate-limit-per-user = json.get "default_thread_rate_limit_per_user"
    default-sort-order = json.get "default_sort_order"
    default-forum-layout = json.get "default_forum_layout"
    is-newly-created = json.get "newly_created"
    thread-member-entry := json.get "thread_member"

  flags -> ChannelFlags:
    return ChannelFlags flags-value

  stringify -> string:
    if name: return "Channel $name ($id)"
    return "Channel $id"

class ChannelFlags:
  /** This thread is pinned to the top if its parent GUILD_FORM channel. */
  static PINNED ::= 1 << 1
  /**
  Whether a tag is required to be specified when creating a thread in a GUILD_FORUM channel.
  Tags are specified in the $Channel.applied-tags field.
  */
  static REQUIRE-TAG ::= 1 << 4

  value/int

  constructor .value:

  is-pinned -> bool:
    return (value & ChannelFlags.PINNED) != 0

  requires-tags -> bool:
    return (value & ChannelFlags.REQUIRE-TAG) != 0

class Overwrite:
  /** The overwrite is for a role. */
  static TYPE-ROLE ::= 0
  /** The overwrite is for a member. */
  static TYPE-MEMBER ::= 1

  /** The id of the role or user */
  id/string

  /**
  The type of the overwrite.
  Either $TYPE-ROLE or $TYPE-MEMBER.
  */
  type/int

  /** The allowed permissions. */
  allow/string

  /** The denied permissions. */
  deny/string

  constructor.from-json json/Map:
    id = json["id"]
    type = json["type"]
    allow = json["allow"]
    deny = json["deny"]

class ThreadMetadata:
  /** Whether the thread is archived. */
  is-archived/bool

  /**
  The duration in minutes to automatically archive the thread after recent activity.
  The thread will stop showing in the channel list after this duration of inactivity.
  Can be set to 60, 1440, 4320, or 10080.
  */
  auto-archive-duration/int

  /**
  The timestamp when the thread's archive status was last changed.
  An ISO8601 timestamp.
  */
  archive-timestamp-value/string

  /**
  Whether the thread is locked.
  When a thread is locked, only users with MANAGE_THREADS can unarchive it.
  */
  is-locked/bool

  /**
  Whether non-moderators can add other non-moderators to a thread.
  Only available on private threads.
  */
  is-invitable/bool?

  /**
  The timestamp when the thread was created.
  An ISO8601 timestamp.
  Only populated for threads created after 2022-01-09.
  */
  create-timestamp-value/string?

  constructor.from-json json/Map:
    is-archived = json["archived"]
    auto-archive-duration = json["auto_archive_duration"]
    archive-timestamp-value = json["archive_timestamp"]
    is-locked = json["locked"]
    is-invitable = json.get "invitable"
    create-timestamp-value = json.get "create_timestamp"

  archive-timestamp -> Time?:
    return archive-timestamp-value and parse-iso8601_ archive-timestamp-value

  create-timestamp -> Time?:
    return create-timestamp-value and parse-iso8601_ create-timestamp-value

class ThreadMember:
  /** The id of the thread. */
  id/string

  /** The id of the user. */
  user-id/string?

  /** The timestamp when the user last joined the thread. */
  join-timestamp-value/string

  /** Any user-thread settings, currently only used for notifications. */
  flags/int

  /**
  Additional information about the user.
  */
  member/GuildMember?

  constructor.from-json json/Map:
    id = json["id"]
    user-id = json.get "user_id"
    join-timestamp-value = json["join_timestamp"]
    flags = json["flags"]
    member-entry := json.get "member"
    if member-entry:
      member = GuildMember.from-json member-entry
    else:
      member = null

class GuildMember:
  /** The user this guild member represents. */
  user/User?

  /** This user's guild nickname. */
  nick/string?

  /** The member's guild avatar hash. */
  avatar/string?

  /** Array of role object ids. */
  roles/List

  /** When the user joined the guild. */
  joined-at-value/string

  /** When the user started boosting the guild. */
  premium-since-value/string?

  /** Whether the user is deafened in voice channels. */
  is-deaf/bool

  /** Whether the user is muted in voice channels. */
  is-mute/bool

  /** Guild member flags represented as a bit set. */
  flags-value/int?

  /**
  Whether the user has not yet passed the guild's Membership Screening requirements.
  */
  is-pending/bool?

  /** Total permissions of the member in the channel, including overwrites. */
  permissions/string?

  /**
  When the user's timeout will expire and the user will be able to communicate in the guild again.
  Null or a time in the past if the user is not timed out.
  */
  communication-disabled-until-value/string?

  constructor.from-json json/Map:
    user-entry := json.get "user"
    if user-entry and not user-entry.is-empty:
      user = User.from-json user-entry
    else:
      user = null
    nick = json.get "nick"
    avatar = json.get "avatar"
    roles = json["roles"]
    joined-at-value = json["joined_at"]
    premium-since-value = json.get "premium_since"
    is-deaf = json["deaf"]
    is-mute = json["mute"]
    flags-value = json.get "flags"
    is-pending = json.get "pending"
    permissions = json.get "permissions"
    communication-disabled-until-value = json.get "communication_disabled_until"

  /** When the user joined the guild. */
  joined-at -> Time:
    return parse-iso8601_ joined-at-value

  /** When the user started boosting the guild. */
  premium-since -> Time?:
    return premium-since-value and parse-iso8601_ premium-since-value

  /**
  When the user's timeout will expire and the user will be able to communicate in the guild again.
  Null or a time in the past if the user is not timed out.
  */
  communication-disabled-until -> Time?:
    return communication-disabled-until-value and parse-iso8601_ communication-disabled-until-value

  /** Guild member flags. */
  flags -> GuildMemberFlags:
    return GuildMemberFlags flags-value

class GuildMemberFlags:
  /** Member has left and rejoined the guild. */
  static DID-REJOIN ::= 1 << 0
  /** Member has completed onboarding. */
  static COMPLETED-ONBOARDING ::= 1 << 1
  /** Member is exempt from guild verification requirements. */
  static BYPASSES-VERIFICATION ::= 1 << 2
  /** Member has started onboarding. */
  static STARTED-ONBOARDING ::= 1 << 3

  value/int

  constructor .value:

  /** Whether the member has left and rejoined the guild. */
  did-rejoin -> bool:
    return (value & DID-REJOIN) != 0

  /** Whether the member has completed onboarding. */
  completed-onboarding -> bool:
    return (value & COMPLETED-ONBOARDING) != 0

  /** Whether the member is exempt from guild verification requirements. */
  bypasses-verification -> bool:
    return (value & BYPASSES-VERIFICATION) != 0

  /** Whether the member has started onboarding. */
  started-onboarding -> bool:
    return (value & STARTED-ONBOARDING) != 0

/**
An object that specifies the emoji to use as the default way to react
  to a forum post.

Exactly one of $emoji-id and $emoji-name must be set.
*/
class DefaultReaction:
  /** The id of a guild's custom emoji. */
  emoji-id/string?

  /** The unicode character of the emoji. */
  emoji-name/string?

  constructor.from-json json/Map:
    emoji-id = json.get "emoji_id"
    emoji-name = json.get "emoji_name"

/**
Represents a message sent in a channel within Discord.
*/
class Message:
  static TYPE-DEFAULT ::= 0
  static TYPE-RECIPIENT-ADD ::= 1
  static TYPE-RECIPIENT-REMOVE ::= 2
  static TYPE-CALL ::= 3
  static TYPE-CHANNEL-NAME-CHANGE ::= 4
  static TYPE-CHANNEL-ICON-CHANGE ::= 5
  static TYPE-CHANNEL-PINNED-MESSAGE ::= 6
  static TYPE-USER-JOIN ::= 7
  static TYPE-GUILD-BOOST ::= 8
  static TYPE-GUILD-BOOST-TIER-1 ::= 9
  static TYPE-GUILD-BOOST-TIER-2 ::= 10
  static TYPE-GUILD-BOOST-TIER-3 ::= 11
  static TYPE-CHANNEL-FOLLOW-ADD ::= 12
  static TYPE-GUILD-DISCOVERY-DISQUALIFIED ::= 14
  static TYPE-GUILD-DISCOVERY-REQUALIFIED ::= 15
  static TYPE-GUILD-DISCOVERY-GRACE-PERIOD-INITIAL-WARNING ::= 16
  static TYPE-GUILD-DISCOVERY-GRACE-PERIOD-FINAL-WARNING ::= 17
  static TYPE-THREAD-CREATED ::= 18
  static TYPE-REPLY ::= 19
  static TYPE-CHAT-INPUT-COMMAND ::= 20
  static TYPE-THREAD-STARTER-MESSAGE ::= 21
  static TYPE-GUILD-INVITE-REMINDER ::= 22
  static TYPE-CONTEXT-MENU-COMMAND ::= 23
  static TYPE-AUTO-MODERATION-ACTION ::= 24
  static TYPE-ROLE-SUBSCRIPTION-PURCHASE ::= 25
  static TYPE-INTERACTION-PREMIUM-UPSELL ::= 26
  static TYPE-STAGE-START ::= 27
  static TYPE-STAGE-END ::= 28
  static TYPE-STAGE-SPEAKER ::= 29
  static TYPE-STAGE-TOPIC ::= 31
  static TYPE-GUILD-APPLICATION-PREMIUM-SUBSCRIPTION ::= 32

  /** The id of the message. */
  id/string

  /** The id of the channel the message was sent in. */
  channel-id/string

  /**
  The author of this message.
  If $webhook-id is null then this field is a $User, otherwise a $WebhookUser.
  */
  author/Author?

  /**
  The content of the message.
  Empty if the app has not configured (or hasn't been approved for) the
    $INTENT-GUILD-MESSAGE-CONTENT privileged intent.
  */
  content/string

  /** When this message was sent. */
  timestamp-value/string

  /** When this message was edited (or null if never). */
  edited-timestamp-value/string?

  /** Whether this was a TTS message. */
  is-tts/bool

  /** Whether this message mentions everyone. */
  mentions-everyone/bool

  /**
  Users specifically mentioned in the message.
  A list of $User objects.
  */
  mentions/List

  /**
  Roles specifically mentioned in this message.
  A list of role object ids.
  */
  mention-roles/List?

  /**
  Channels specifically mentioned in this message.
  A list of $ChannelMention objects.

  Not all channel mentions in a message appear in this field. Only textual
    channels that are visible to everyone in a lurkable guild are included.
  Only crossposted messages (via Channel Following) currently include
    this field at all. If no mentions in the message meet these requirements,
    this field is null.
  */
  mention-channels/List?

  /**
  Attached files.
  A list of $Attachment objects.

  Empty if the app has not configured (or hasn't been approved for) the
    $INTENT-GUILD-MESSAGE-CONTENT privileged intent.
  */
  attachments/List?

  /**
  Embedded content.
  A list of $Embed objects.
  */
  embeds/List

  /**
  Reactions to the message.
  A list of $Reaction objects.
  */
  reactions/List?

  /**
  Used for validating a message was sent.
  */
  nonce/string?

  /** Whether this message is pinned. */
  is-pinned/bool

  /**
  If the message is generated by a webhook, this is the webhook's id.
  */
  webhook-id/string?

  /**
  The type of message.
  See $TYPE-DEFAULT and other TYPE constants.
  */
  type/int

  /**
  Sent with Rich Presence-related chat embeds.
  */
  activity/MessageActivity?

  /**
  Sent with Rich Presence-related chat embeds.
  */
  application/Application?

  /**
  The id of the application.
  Null, unless the message is an interaction or application-owned webhook.
  */
  application-id/string?

  /**
  Data showing the source of a crosspost, channel follow add, pin, or reply message.
  */
  message-reference/MessageReference?

  /**
  Message flags combined as a bitfield.
  */
  flags-value/int?

  /**
  The message associated with the message_reference.

  Only returned for type $TYPE-REPLY or $TYPE-THREAD-STARTER-MESSAGE.
  If the message is a reply but the referenced_message is missing, the
    backend did not attempt to fetch that message, so its state is unknown.
  */
  referenced-message/Message?

  /**
  Sent if the message is a response to an Interaction.
  */
  interaction/MessageInteraction?

  /**
  The thread that was started from this message, includes the $ThreadMember object.
  */
  thread/Channel?

  /**
  Sent if the message contains components like buttons, action rows, or other interactive components.
  Empty if the app has not configured (or hasn't been approved for) the
    $INTENT-GUILD-MESSAGE-CONTENT privileged intent.
  A list of $Component objects.
  */
  components/List?

  /**
  Sent if the message contains stickers.
  A list of $StickerItem objects.
  */
  sticker-items/List?

  /**
  A generally increasing integer that represents the approximate
    position of the message in a thread.
  It can be used to estimate the relative position of the message in a thread
    in company with total_message_sent on parent thread.
  */
  position/int?

  /**
  Data of the role subscription purchase or renewal that prompted this
    ROLE_SUBSCRIPTION_PURCHASE message.
  */
  role-subscription-data/RoleSubscriptionData?

  /** The guild id of the message. */
  guild-id/string?

  /** The (partial) guild member object of the message's author. */
  member/GuildMember?

  constructor.from-json json/Map:
    id = json["id"]
    channel-id = json["channel_id"]
    if json.get "webhook_id":
      author = WebhookUser.from-json json
    else:
      author-entry := json.get "author"
      if author-entry:
        author = User.from-json author-entry
      else:
        author = null
    content = json["content"]
    timestamp-value = json["timestamp"]
    edited-timestamp-value = json.get "edited_timestamp"
    is-tts = json["tts"]
    mentions-everyone = json["mention_everyone"]
    mentions = json["mentions"].map: User.from-json it
    mention-roles = json.get "mention_roles"
    mention-channels-entry := json.get "mention_channels"
    if mention-channels-entry:
      mention-channels = mention-channels-entry.map: ChannelMention.from-json it
    else:
      mention-channels = null
    attachments = json["attachments"].map: Attachment.from-json it
    embeds = json["embeds"].map: Embed.from-json it
    reactions-entry := json.get "reactions"
    if reactions-entry:
      reactions = reactions-entry.map: Reaction.from-json it
    else:
      reactions = null
    nonce = json.get "nonce"
    is-pinned = json["pinned"]
    webhook-id = json.get "webhook_id"
    type = json["type"]
    activity-entry := json.get "activity"
    if activity-entry:
      activity = MessageActivity.from-json activity-entry
    else:
      activity = null
    application-entry := json.get "application"
    if application-entry:
      application = Application.from-json application-entry
    else:
      application = null
    application-id = json.get "application_id"
    message-reference-entry := json.get "message_reference"
    if message-reference-entry:
      message-reference = MessageReference.from-json message-reference-entry
    else:
      message-reference = null
    flags-value = json.get "flags"
    referenced-message-entry := json.get "referenced_message"
    if referenced-message-entry:
      referenced-message = Message.from-json referenced-message-entry
    else:
      referenced-message = null
    interaction-entry := json.get "interaction"
    if interaction-entry:
      interaction = MessageInteraction.from-json interaction-entry
    else:
      interaction = null
    thread-entry := json.get "thread"
    if thread-entry:
      thread = Channel.from-json thread-entry
    else:
      thread = null
    components-entry := json.get "components"
    if components-entry:
      components = components-entry.map: Component.from-json it
    else:
      components = null
    sticker-items-entry := json.get "sticker_items"
    if sticker-items-entry:
      sticker-items = sticker-items-entry.map: StickerItem.from-json it
    else:
      sticker-items = null
    position = json.get "position"
    role-subscription-data-entry := json.get "role_subscription_data"
    if role-subscription-data-entry:
      role-subscription-data = RoleSubscriptionData.from-json role-subscription-data-entry
    else:
      role-subscription-data = null
    if json.get "guild_id":
      guild-id = json["guild_id"]
    else:
      guild-id = null
    member-entry := json.get "member"
    if member-entry:
      member = GuildMember.from-json member-entry
    else:
      member = null

  flags -> MessageFlags?:
    if flags-value == null: return null
    return MessageFlags flags-value

  timestamp -> Time:
    return parse-iso8601_ timestamp-value

  edited-timestamp -> Time?:
    if not edited-timestamp-value: return null
    return parse-iso8601_ edited-timestamp-value

  stringify -> string:
    return "$author.username: $content"

class MessageFlags:
  /** This message has been published to subscribed channels (via Channel Following). */
  static CROSSPOSTED ::= 1 << 0
  /** This message originated from a message in another channel (via Channel Following). */
  static IS-CROSSPOST ::= 1 << 1
  /** Do not include any embeds when serializing this message. */
  static SUPPRESS-EMBEDS ::= 1 << 2
  /** The source message for this crosspost has been deleted (via Channel Following). */
  static SOURCE-MESSAGE-DELETED ::= 1 << 3
  /** This message came from the urgent message system. */
  static URGENT ::= 1 << 4
  /** This message has an associated thread, with the same id as the message. */
  static HAS-THREAD ::= 1 << 5
  /** This message is only visible to the user who invoked the Interaction. */
  static EPHEMERAL ::= 1 << 6
  /** This message is an Interaction Response and the bot is "thinking". */
  static LOADING ::= 1 << 7
  /** This message failed to mention some roles and add their members to the thread. */
  static FAILED-TO-MENTION-SOME-ROLES-IN-THREAD ::= 1 << 8
  /** This message will not trigger push and desktop notifications. */
  static SUPPRESS-NOTIFICATIONS ::= 1 << 12

  value/int

  constructor .value:

  /** Whether this message has been published to subscribed channels (via Channel Following). */
  crossposted -> bool:
    return (value & MessageFlags.CROSSPOSTED) != 0

  /** Whether this message originated from a message in another channel (via Channel Following). */
  is-crosspost -> bool:
    return (value & MessageFlags.IS-CROSSPOST) != 0

  /** Whether to not include any embeds when serializing this message. */
  should-suppress-embeds -> bool:
    return (value & MessageFlags.SUPPRESS-EMBEDS) != 0

  /** Whether the source message for this crosspost has been deleted (via Channel Following). */
  is-source-message-deleted -> bool:
    return (value & MessageFlags.SOURCE-MESSAGE-DELETED) != 0

  /** Whether this message came from the urgent message system. */
  is-urgent -> bool:
    return (value & MessageFlags.URGENT) != 0

  /** Whether this message has an associated thread, with the same id as the message. */
  has-thread -> bool:
    return (value & MessageFlags.HAS-THREAD) != 0

  /** Whether this message is only visible to the user who invoked the Interaction. */
  is-ephemeral -> bool:
    return (value & MessageFlags.EPHEMERAL) != 0

  /** Whether this message is an Interaction Response and the bot is "thinking". */
  is-loading -> bool:
    return (value & MessageFlags.LOADING) != 0

  /** Whether this message failed to mention some roles and add their members to the thread. */
  failed-to-mention-some-roles-in-thread -> bool:
    return (value & MessageFlags.FAILED-TO-MENTION-SOME-ROLES-IN-THREAD) != 0

  /** Whether this message will not trigger push and desktop notifications. */
  suppresses-notifications -> bool:
    return (value & MessageFlags.SUPPRESS-NOTIFICATIONS) != 0

/**
The author of a message that was sent by a webhook.
*/
class WebhookUser implements Author:
  /** The id of the webhook. */
  id/string

  /** The username of the webhook. */
  username/string?

  /** The avatar hash of the webhook. */
  avatar/string?

  constructor.from-json json/Map:
    id = json["id"]
    username = json.get "username"
    avatar = json.get "avatar"

class ChannelMention:
  /** The id of the channel. */
  id/string

  /** The id of the guild containing the channel. */
  guild-id/string

  /**
  The type of channel.
  See $Channel.type.
  */
  type/int

  /** The name of the channel. */
  name/string

  constructor.from-json json/Map:
    id = json["id"]
    guild-id = json["guild_id"]
    type = json["type"]
    name = json["name"]

class Attachment:
  /** The id of the attachment. */
  id/string

  /** The name of the file attached. */
  filename/string

  /** The description of the file (max 1024 characters). */
  description/string?

  /** The media type of the attachment. */
  content-type/string?

  /** The size of the file in bytes. */
  size/int

  /** The source url of the file. */
  url/string

  /** A proxied url of the file. */
  proxy-url/string

  /** The height of the file (if image). */
  height/int?

  /** The width of the file (if image). */
  width/int?

  /** Whether this attachment is ephemeral. */
  is-ephemeral/bool?

  constructor.from-json json/Map:
    id = json["id"]
    filename = json["filename"]
    description = json.get "description"
    content-type = json.get "content_type"
    size = json["size"]
    url = json["url"]
    proxy-url = json["proxy_url"]
    height = json.get "height"
    width = json.get "width"
    is-ephemeral = json.get "ephemeral"

class Embed:
  /** A generic embed rendered from embed attributes. */
  static TYPE-RICH ::= "rich"
  /** An image embed. */
  static TYPE-IMAGE ::= "image"
  /** A video embed. */
  static TYPE-VIDEO ::= "video"
  /** An animated gif image embed rendered as a video embed. */
  static TYPE-GIFV ::= "gifv"
  /** An article embed. */
  static TYPE-ARTICLE ::= "article"
  /** A link embed. */
  static TYPE-LINK ::= "link"

  /** The title of the embed. */
  title/string?

  /**
  The type of the embed.
  One of:
  - $TYPE-RICH
  - $TYPE-IMAGE
  - $TYPE-VIDEO
  - $TYPE-GIFV
  - $TYPE-ARTICLE
  - $TYPE-LINK
  */
  type/string?

  /** The description of the embed. */
  description/string?

  /** The url of the embed. */
  url/string?

  /** The timestamp of the embed content. */
  timestamp-value/string?

  /** The color code of the embed. */
  color/int?

  /** The footer information of the embed. */
  footer/EmbedFooter?

  /** The image information of the embed. */
  image/EmbedImage?

  /** The thumbnail information of the embed. */
  thumbnail/EmbedThumbnail?

  /** The video information of the embed. */
  video/EmbedVideo?

  /** The provider information of the embed. */
  provider/EmbedProvider?

  /** The author information of the embed. */
  author/EmbedAuthor?

  /** The fields information of the embed. */
  fields/List?

  constructor.from-json json/Map:
    title = json.get "title"
    type = json.get "type"
    description = json.get "description"
    url = json.get "url"
    timestamp-value = json.get "timestamp"
    color = json.get "color"
    footer-entry := json.get "footer"
    if footer-entry:
      footer = EmbedFooter.from-json footer-entry
    else:
      footer = null
    image-entry := json.get "image"
    if image-entry:
      image = EmbedImage.from-json image-entry
    else:
      image = null
    thumbnail-entry := json.get "thumbnail"
    if thumbnail-entry:
      thumbnail = EmbedThumbnail.from-json thumbnail-entry
    else:
      thumbnail = null
    video-entry := json.get "video"
    if video-entry:
      video = EmbedVideo.from-json video-entry
    else:
      video = null
    provider-entry := json.get "provider"
    if provider-entry:
      provider = EmbedProvider.from-json provider-entry
    else:
      provider = null
    author-entry := json.get "author"
    if author-entry:
      author = EmbedAuthor.from-json author-entry
    else:
      author = null
    fields-entry := json.get "fields"
    if fields-entry:
      fields = fields-entry.map: EmbedField.from-json it
    else:
      fields = []

class EmbedAuthor:
  /** The name of the author. */
  name/string

  /**
  The url of the author.
  Only supports http(s).
  */
  url/string?

  /**
  The url of the author icon.
  Only supports http(s) and attachments.
  */
  icon-url/string?

  /** A proxied url of the author icon. */
  proxy-icon-url/string?

  constructor.from-json json/Map:
    name = json["name"]
    url = json.get "url"
    icon-url = json.get "icon_url"
    proxy-icon-url = json.get "proxy_icon_url"

class EmbedFooter:
  /** The text of the footer. */
  text/string

  /** The url of the footer icon. */
  icon-url/string?

  /** A proxied url of the footer icon. */
  proxy-icon-url/string?

  constructor.from-json json/Map:
    text = json["text"]
    icon-url = json.get "icon_url"
    proxy-icon-url = json.get "proxy_icon_url"

class EmbedImage:
  /** The source url of the image. */
  url/string

  /** A proxied url of the image. */
  proxy-url/string?

  /** The height of the image. */
  height/int?

  /** The width of the image. */
  width/int?

  constructor.from-json json/Map:
    url = json["url"]
    proxy-url = json.get "proxy_url"
    height = json.get "height"
    width = json.get "width"

class EmbedThumbnail:
  /** The source url of the thumbnail. */
  url/string

  /** A proxied url of the thumbnail. */
  proxy-url/string?

  /** The height of the thumbnail. */
  height/int?

  /** The width of the thumbnail. */
  width/int?

  constructor.from-json json/Map:
    url = json["url"]
    proxy-url = json.get "proxy_url"
    height = json.get "height"
    width = json.get "width"

class EmbedVideo:
  /** The source url of the video. */
  url/string

  /** A proxied url of the video. */
  proxy-url/string?

  /** The height of the video. */
  height/int?

  /** The width of the video. */
  width/int?

  constructor.from-json json/Map:
    url = json["url"]
    proxy-url = json.get "proxy_url"
    height = json.get "height"
    width = json.get "width"

class EmbedProvider:
  /** The name of the provider. */
  name/string?

  /** The url of the provider. */
  url/string?

  constructor.from-json json/Map:
    name = json.get "name"
    url = json.get "url"

class EmbedField:
  /** The name of the field. */
  name/string

  /** The value of the field. */
  value/string

  /** Whether or not this field should display inline. */
  inline/bool?

  constructor.from-json json/Map:
    name = json["name"]
    value = json["value"]
    inline = json.get "inline"

class Reaction:
  /** The times this emoji has been used to react. */
  count/int

  /** Whether the current user reacted using this emoji. */
  me/bool

  /** (Partial) emoji information. */
  emoji/Emoji

  constructor.from-json json/Map:
    count = json["count"]
    me = json["me"]
    emoji = Emoji.from-json json["emoji"]

class MessageActivity:
  static TYPE-JOIN ::= 1
  static TYPE-SPECTATE ::= 2
  static TYPE-LISTEN ::= 3
  static TYPE-JOIN-REQUEST ::= 5

  /**
  Type of message activity.
  One of:
  - $TYPE-JOIN
  - $TYPE-SPECTATE
  - $TYPE-LISTEN
  - $TYPE-JOIN-REQUEST
  */
  type/int

  /** Party id from a Rich Presence event. */
  party-id/string?

  constructor.from-json json/Map:
    type = json["type"]
    party-id = json.get "party_id"

class Application:
  /** The id of the app. */
  id/string

  /** The name of the app. */
  name/string?

  /** The icon hash of the app. */
  icon/string?

  /** The description of the app. */
  description/string?

  /** An array of rpc origin urls, if rpc is enabled. */
  rpc-origins/List?

  /**
  Whether anyone (and not only the app owner) can join the app's bot
    to guilds.
  */
  bot-is-public/bool?

  /**
  Whether the app's bot will only join upon completion of the full oauth2
    code grant flow.
  */
  bot-requires-code-grant/bool?

  /** The url of the app's terms of service. */
  terms-of-service-url/string?

  /** The url of the app's privacy policy. */
  privacy-policy-url/string?

  /** Partial user object containing info on the owner of the application. */
  owner/User?

  /** The hex encoded key for verification in interactions and the GameSDK's GetTicket. */
  verify-key/string?

  /**
  The members of the team.

  If the application belongs to a team, this will be a list of the members of that team. */
  team/Team?

  /** The guild to which it has been linked. */
  guild-id/string?

  /** The id of the "Game SKU" that is created, if exists. */
  primary-sku-id/string?

  /** The URL slug that links to the store page. */
  slug/string?

  /** The application's default rich presence invite cover image hash. */
  cover-image/string?

  /** The application's public flags. */
  flags-value/int?

  /** Up to 5 tags describing the content and functionality of the application. */
  tags/List?

  /** Settings for the application's default in-app authorization link, if enabled. */
  install-params/InstallParams?

  /** The application's default custom authorization link, if enabled. */
  custom-install-url/string?

  /**
  The application's role connection verification entry point.
  When configured renders the app as a verification method in the guild role
    verification configuration.
  */
  role-connections-verification-url/string?

  constructor.from-json json/Map:
    id = json["id"]
    name = json.get "name"
    icon = json.get "icon"
    description = json.get "description"
    rpc-origins = json.get "rpc_origins"
    bot-is-public = json.get "bot_public"
    bot-requires-code-grant = json.get "bot_require_code_grant"
    terms-of-service-url = json.get "terms_of_service_url"
    privacy-policy-url = json.get "privacy_policy_url"
    owner-entry := json.get "owner"
    if owner-entry:
      owner = User.from-json owner-entry
    else:
      owner = null
    verify-key = json.get "verify_key"
    team-entry := json.get "team"
    if team-entry:
      team = Team.from-json team-entry
    else:
      team = null
    guild-id = json.get "guild_id"
    primary-sku-id = json.get "primary_sku_id"
    slug = json.get "slug"
    cover-image = json.get "cover_image"
    flags-value = json.get "flags"
    tags = json.get "tags"
    install-params-entry := json.get "install_params"
    if install-params-entry:
      install-params = InstallParams.from-json install-params-entry
    else:
      install-params = null
    custom-install-url = json.get "custom_install_url"
    role-connections-verification-url = json.get "role_connections_verification_url"

class Team:
  /** The unique id of the team. */
  id/string

  /** A hash of the image of the team's icon. */
  icon/string?

  /** The name of the team. */
  name/string?

  /** The user id of the current team owner. */
  owner-user-id/string?

  /**
  The members of the team.
  A list of $TeamMember objects.
  */
  members/List

  constructor.from-json json/Map:
    id = json["id"]
    icon = json.get "icon"
    name = json.get "name"
    owner-user-id = json.get "owner_user_id"
    members = json["members"].map: TeamMember.from-json it

class TeamMember:
  static MEMBERSHIP-INVITED ::= 1
  static MEMBERSHIP-ACCEPTED ::= 2

  /**
  The user's membership state on the team.
  Either $MEMBERSHIP-INVITED or $MEMBERSHIP-ACCEPTED.
  */
  membership-state/int

  /**
  Permissions.
  Always equal to a list with a the single entry "*".
  */
  permissions/List

  /** The id of the parent team of which they are a member. */
  team-id/string

  /** The avatar, discriminator, id, and username of the user. */
  user/User

  constructor.from-json json/Map:
    membership-state = json["membership_state"]
    permissions = json["permissions"]
    team-id = json["team_id"]
    user = User.from-json json["user"]

class InstallParams:
  /** The scopes to add the application to the server with. */
  scopes/List

  /** The permissions to request for the bot role. */
  permissions/string

  constructor.from-json json/Map:
    scopes = json["scopes"]
    permissions = json["permissions"]

class MessageReference:
  /** The id of the originating message. */
  message-id/string?

  /** The id of the originating message's channel. */
  channel-id/string?

  /** The id of the originating message's guild. */
  guild-id/string?

  /**
  Whether to error if the referenced message doesn't exist.
  When sending, fails if the referenced message doesn't exist.
  If false, sends as a normal (non-reply) message.
  Default is true.
  */
  fail-if-not-exists/bool?

  constructor.from-json json/Map:
    message-id = json.get "message_id"
    channel-id = json.get "channel_id"
    guild-id = json.get "guild_id"
    fail-if-not-exists = json.get "fail_if_not_exists"

class MessageInteraction:
  /** The id of the interaction. */
  id/string

  /** The type of interaction. */
  type/int

  /**
  The name of the application command.
  Includes subcommands and subcommand groups.
  */
  name/string

  /** The user who invoked the interaction. */
  user/User

  /** The (partial) member who invoked the interaction in the guild. */
  member/GuildMember?

  constructor.from-json json/Map:
    id = json["id"]
    type = json["type"]
    name = json["name"]
    user = User.from-json json["user"]
    member-entry := json.get "member"
    if member-entry:
      member = GuildMember.from-json member-entry
    else:
      member = null

class Component:
  /** Container for other components. */
  static TYPE-ACTION-ROW ::= 1
  /** Button object. */
  static TYPE-BUTTON ::= 2
  /** Select menu for picking from defined text options. */
  static TYPE-STRING-SELECT ::= 3
  /** Text input object. */
  static TYPE-TEXT-INPUT ::= 4
  /** Select menu for users. */
  static TYPE-USER-SELECT ::= 5
  /** Select menu for roles. */
  static TYPE-ROLE-SELECT ::= 6
  /** Select menu for mentionables (users and roles). */
  static TYPE-MENTIONABLE-SELECT ::= 7
  /** Select menu for channels. */
  static TYPE-CHANNEL-SELECT ::= 8

  /** The type of the component. */
  type/int

  constructor.from-json json/Map:
    type := json["type"]
    if type == TYPE-ACTION-ROW:
      return ComponentActionRow.from-json json
    else if type == TYPE-BUTTON:
      return ComponentButton.from-json json
    else if type == TYPE-STRING-SELECT or
        type == TYPE-USER-SELECT or
        type == TYPE-ROLE-SELECT or
        type == TYPE-MENTIONABLE-SELECT or
        type == TYPE-CHANNEL-SELECT:
      return ComponentSelect.from-json json
    else if type == TYPE-TEXT-INPUT:
      return ComponentTextInput.from-json json
    else:
      throw "Unknown component type $type"

  constructor .type/int:

class ComponentActionRow extends Component:
  /** A list of subcomponents of type $Component. */
  components/List

  constructor.from-json json/Map:
    components = json["components"].map: Component.from-json it
    super json["type"]

class ComponentButton extends Component:
  /** The primary style. Color blurple. */
  static STYLE-PRIMARY ::= 1
  /** The secondary style. Color grey. */
  static STYLE-SECONDARY ::= 2
  /** The success style. Color green. */
  static STYLE-SUCCESS ::= 3
  /** The danger style. Color red. */
  static STYLE-DANGER ::= 4
  /** The link style. Color grey. Navigates to a URL. */
  static STYLE-LINK ::= 5

  /**
  The style of the button.
  One of $STYLE-PRIMARY, $STYLE-SECONDARY, $STYLE-SUCCESS, $STYLE-DANGER, or $STYLE-LINK.
  */
  style/int

  /** The text that appears on the button. */
  label/string?

  /** The emoji that appears on the button. */
  emoji/Emoji?

  /** The custom id of the button. */
  custom-id/string?

  /** The url of the button. */
  url/string?

  /** Whether the button is disabled. */
  is-disabled/bool?

  constructor.from-json json/Map:
    style = json["style"]
    label = json.get "label"
    emoji-entry := json.get "emoji"
    if emoji-entry:
      emoji = Emoji.from-json emoji-entry
    else:
      emoji = null
    custom-id = json.get "custom_id"
    url = json.get "url"
    is-disabled = json.get "disabled"
    super json["type"]

class ComponentSelect extends Component:
  /**
  The custom id of the select menu.
  Max 100 characters.
  */
  custom-id/string

  /**
  The options of the select menu.
  Only applicable (and required) for string selects (type $Component.TYPE-STRING-SELECT).
  A list of $SelectOption.
  */
  options/List?

  /**
  The channel types to include in the channel select component.
  Only applicable for channel selects (type $Component.TYPE-CHANNEL-SELECT).
  See $Channel.type.
  */
  channel-types/List?

  /**
  The placeholder text if nothing is selected.
  Max 150 characters.
  */
  placeholder/string?

  /**
  The minimum number of items that must be chosen.
  Defaults to 1.
  Min 0, max 25.
  */
  min-values/int?

  /**
  The maximum number of items that can be chosen.
  Defaults to 1.
  Max 25.
  */
  max-values/int?

  /**
  Whether the select menu is disabled.
  Defaults to false.
  */
  is-disabled/bool?

  constructor.from-json json/Map:
    custom-id = json["custom_id"]
    options-entry := json.get "options"
    if options-entry:
      options = options-entry.map: SelectOption.from-json it
    else:
      options = null
    channel-types = json.get "channel_types"
    placeholder = json.get "placeholder"
    min-values = json.get "min_values"
    max-values = json.get "max_values"
    is-disabled = json.get "disabled"
    super json["type"]

class SelectOption:
  /**
  User-facing name of the option.
  Max 100 characters.
  */
  label/string

  /**
  Developer-defined value of the option.
  Max 100 characters.
  */
  value/string

  /**
  Additional description of the option.
  Max 100 characters.
  */
  description/string?

  /** The emoji that appears on the option. */
  emoji/Emoji?

  /**
  Whether this option is selected by default.
  Defaults to false.
  */
  is-default/bool?

  constructor.from-json json/Map:
    label = json["label"]
    value = json["value"]
    description = json.get "description"
    emoji-entry := json.get "emoji"
    if emoji-entry:
      emoji = Emoji.from-json emoji-entry
    else:
      emoji = null
    is-default = json.get "default"

class ComponentTextInput extends Component:
  /** Single-line input. */
  static STYLE-SHORT ::= 1
  /** Multi-line input. */
  static STYLE-PARAGRAPH ::= 2

  /** The developer-defined identifier for the input. */
  custom-id/string

  /**
  The text input style.
  Either $STYLE-SHORT or $STYLE-PARAGRAPH.
  */
  style/int

  /**
  The label for this component.
  Max 45 characters.
  */
  label/string

  /**
  The minimum input length for a text input.
  Min 0, max 4000.
  */
  min-length/int?

  /**
  The maximum input length for a text input.
  Min 1, max 4000.
  */
  max-length/int?

  /**
  Whether this component is required to be filled.
  Defaults to true.
  */
  is-required/bool?

  /**
  The pre-filled value for this component.
  Max 4000 characters.
  */
  value/string?

  /**
  The custom placeholder text if the input is empty.
  Max 100 characters.
  */
  placeholder/string?

  constructor.from-json json/Map:
    custom-id = json["custom_id"]
    style = json["style"]
    label = json["label"]
    min-length = json.get "min_length"
    max-length = json.get "max_length"
    is-required = json.get "required"
    value = json.get "value"
    placeholder = json.get "placeholder"
    super json["type"]

class StickerItem:
  /** The id of the sticker. */
  id/string

  /** The name of the sticker. */
  name/string

  /**
  The type of sticker format.
  See $Sticker.format-type.
  */
  format-type/int

  constructor.from-json json/Map:
    id = json["id"]
    name = json["name"]
    format-type = json["format_type"]

class RoleSubscriptionData:
  /** The id of the sku and listing that the user is subscribed to. */
  role-subscription-listing-id/string

  /** The name of the tier that the user is subscribed to. */
  tier-name/string

  /** The cumulative number of months that the user has been subscribed for. */
  total-months-subscribed/int

  /** Whether this notification is for a renewal rather than a new purchase. */
  is-renewal/bool

  constructor.from-json json/Map:
    role-subscription-listing-id = json["role_subscription_listing_id"]
    tier-name = json["tier_name"]
    total-months-subscribed = json["total_months_subscribed"]
    is-renewal = json["is_renewal"]

parse-iso8601_ str/string? -> Time:
  // TODO(florian): Improve core libraries to be able to parse these timestamps.
    is-utc := str.ends-with "Z" or str.ends-with "+00:00"
    str = str.trim --right "Z"
    str = str.trim --right "+00:00"
    parts ::= str.split "T"
    str-to-int ::= :int.parse it --on-error=: throw "Cannot parse $it as integer"
    if parts.size != 2: throw "Expected T to separate date and time"
    date-parts ::= (parts[0].split "-").map str-to-int
    if date-parts.size != 3: throw "Expected 3 segments separated by - for date"
    time-string-parts ::= parts[1].split ":"
    if time-string-parts.size != 3: throw "Expected 3 segments separated by : for time"
    if time-string-parts[2].contains ".":
      split := time-string-parts[2].split "."
      time-string-parts[2] = split[0]
      time-string-parts.add "$split[1]000000000"[..9]
    else:
      time-string-parts.add "0"
    time-parts := time-string-parts.map: int.parse it
    return Time.local-or-utc_
      date-parts[0]
      date-parts[1]
      date-parts[2]
      time-parts[0]
      time-parts[1]
      time-parts[2]
      --ms=0
      --us=0
      --ns=time-parts[3]
      --is-utc=is-utc
