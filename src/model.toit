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
  static BUG_HUNTER_LEVEL_1 ::= 1 << 3
  /** A house bravery member. */
  static HOUSE_BRAVERY ::= 1 << 6
  /** A house brilliance member. */
  static HOUSE_BRILLIANCE ::= 1 << 7
  /** A house balance member. */
  static HOUSE_BALANCE ::= 1 << 8
  /** A early Nitro supporter. */
  static EARLY_SUPPORTER ::= 1 << 9
  /** A team user. */
  static TEAM_PSEUDO_USER ::= 1 << 10
  /** A bug hunter level 2. */
  static BUG_HUNTER_LEVEL_2 ::= 1 << 14
  /** A verified bot. */
  static VERIFIED_BOT ::= 1 << 16
  /** A verified bot developer. */
  static VERIFIED_DEVELOPER ::= 1 << 17
  /** Moderator Programs Alumni. */
  static USER_CERTIFIED_MODERATOR ::= 1 << 18
  /** Flag that the bot only uses HTTP interactions and is shown in the online member list. */
  static USER_BOT_HTTP_INTERACTIONS ::= 1 << 19
  /** An active developer. */
  static USER_ACTIVE_DEVELOPER ::= 1 << 22

  value/int

  constructor .value:

  /** Whether the user is a discord employee. */
  is_staff -> bool: return (value & STAFF) != 0
  /** Whether the user is a partnered server owner. */
  is_partner -> bool: return (value & PARTNER) != 0
  /** Whether the user is a hypesquad events participant. */
  is_hypesquad -> bool: return (value & HYPESQUAD) != 0
  /** Whether the user is a bug hunter level 1. */
  is_bug_hunter_level_1 -> bool: return (value & BUG_HUNTER_LEVEL_1) != 0
  /** Whether the user is a house bravery member. */
  is_house_bravery -> bool: return (value & HOUSE_BRAVERY) != 0
  /** Whether the user is a house brilliance member. */
  is_house_brilliance -> bool: return (value & HOUSE_BRILLIANCE) != 0
  /** Whether the user is a house balance member. */
  is_house_balance -> bool: return (value & HOUSE_BALANCE) != 0
  /** Whether the user is a early Nitro supporter. */
  is_early_supporter -> bool: return (value & EARLY_SUPPORTER) != 0
  /** Whether the user is a team user. */
  is_team_pseudo_user -> bool: return (value & TEAM_PSEUDO_USER) != 0
  /** Whether the user is a bug hunter level 2. */
  is_bug_hunter_level_2 -> bool: return (value & BUG_HUNTER_LEVEL_2) != 0
  /** Whether the user is a verified bot. */
  is_verified_bot -> bool: return (value & VERIFIED_BOT) != 0
  /** Whether the user is a verified bot developer. */
  is_verified_developer -> bool: return (value & VERIFIED_DEVELOPER) != 0
  /** Whether the user is a moderator programs alumni. */
  is_user_certified_moderator -> bool: return (value & USER_CERTIFIED_MODERATOR) != 0
  /** Whether the bot only uses HTTP interactions and is shown in the online member list. */
  is_user_bot_http_interactions -> bool: return (value & USER_BOT_HTTP_INTERACTIONS) != 0
  /** Whether the user is an active developer. */
  is_user_active_developer -> bool: return (value & USER_ACTIVE_DEVELOPER) != 0

  stringify -> string:
    result := "Flags ($value)"
    flag_strings := []
    if is_staff: flag_strings.add "discord employee"
    if is_partner: flag_strings.add "partnered server owner"
    if is_hypesquad: flag_strings.add "hypesquad events participant"
    if is_bug_hunter_level_1: flag_strings.add "bug hunter level 1"
    if is_house_bravery: flag_strings.add "house bravery member"
    if is_house_brilliance: flag_strings.add "house brilliance member"
    if is_house_balance: flag_strings.add "house balance member"
    if is_early_supporter: flag_strings.add "early Nitro supporter"
    if is_team_pseudo_user: flag_strings.add "team user"
    if is_bug_hunter_level_2: flag_strings.add "bug hunter level 2"
    if is_verified_bot: flag_strings.add "verified bot"
    if is_verified_developer: flag_strings.add "verified bot developer"
    if is_user_certified_moderator: flag_strings.add "moderator programs alumni"
    if is_user_bot_http_interactions: flag_strings.add "bot only uses HTTP interactions"
    if is_user_active_developer: flag_strings.add "active developer"
    if flag_strings.is_empty: return result
    return "$result: $(flag_strings.join ", ")"

class PremiumType:
  /** None. */
  static NONE ::= 0
  /** Nitro Classic. */
  static NITRO_CLASSIC ::= 1
  /** Nitro. */
  static NITRO ::= 2
  /** Nitro Basic. */
  static NITRO_BASIC ::= 3

  value/int

  constructor .value:

  stringify -> string:
    if value == NONE: return "None"
    if value == NITRO_CLASSIC: return "Nitro Classic"
    if value == NITRO: return "Nitro"
    if value == NITRO_BASIC: return "Nitro Basic"
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
  is_bot/bool?

  /** Whether the user is an Official Discord System user (part of the urgent message system). */
  is_system/bool?

  /** Whether the user has two factor enabled on their account. */
  is_mfa_enabled/bool?

  /** The user's banner hash. */
  banner/string?

  /**
  The user's accent color.
  The color is encoded as an integer representation of hexadecimal color code.
  */
  accent_color/int?

  /** The user's chosen language option. */
  locale/string?

  /** Whether the email on this account has been verified. */
  is_verified/bool?

  /** The user's email. */
  email/string?

  /** The flags on a user's account. */
  flags_value/int?

  /** The type of Nitro subscription on a user's account. */
  premium_type/int?

  /** The public flags on a user's account. */
  public_flags_value/int?

  constructor.from_json json/Map:
    id = json["id"]
    username = json["username"]
    discriminator = json["discriminator"]
    avatar = json.get "avatar"
    is_bot = json.get "bot"
    is_system = json.get "system"
    is_mfa_enabled = json.get "mfa_enabled"
    banner = json.get "banner"
    accent_color = json.get "accent_color"
    locale = json.get "locale"
    is_verified = json.get "verified"
    email = json.get "email"
    flags_value = json.get "flags"
    premium_type = json.get "premium_type"
    public_flags_value = json.get "public_flags"

  /** The flags on a user's account. */
  flags -> UserFlags?:
    return flags_value and UserFlags flags_value

  /** The public flags on a user's account. */
  public_flags -> UserFlags?:
    return public_flags_value and UserFlags public_flags_value

  stringify -> string:
    return "User<id: $id, username: $username, discriminator: $discriminator>"

class SystemChannelFlags:
  /** Suppress member join notifications. */
  static SUPPRESS_JOIN_NOTIFICATIONS ::= 1 << 0
  /** Suppress server boost notifications. */
  static SUPPRESS_PREMIUM_SUBSCRIPTIONS ::= 1 << 1
  /** Suppress server setup tips. */
  static SUPPRESS_GUILD_REMINDER_NOTIFICATIONS ::= 1 << 2
  /** Hide member join sticker reply buttons. */
  static SUPPRESS_JOIN_NOTIFICATIONS_REPLIES ::= 1 << 3
  /** Suppress role subscription purchase and renewal notifications. */
  static SUPPRESS_ROLE_SUBSCRIPTION_PURCHASE_NOTIFICATIONS ::= 1 << 4
  /** Hide role subscription sticker reply buttons. */
  static SUPPRESS_ROLE_SUBSCRIPTION_PURCHASE_NOTIFICATION_REPLIES ::= 1 << 5

  value/int

  constructor .value:

  /** Whether member join notifications are suppressed. */
  suppresses_join_notifications -> bool:
    return (value & SUPPRESS_JOIN_NOTIFICATIONS) != 0

  /** Whether server boost notifications are suppressed. */
  suppresses_premium_subscriptions -> bool:
    return (value & SUPPRESS_PREMIUM_SUBSCRIPTIONS) != 0

  /** Whether server setup tips are suppressed. */
  suppresses_guild_reminder_notifications -> bool:
    return (value & SUPPRESS_GUILD_REMINDER_NOTIFICATIONS) != 0

  /** Whether member join sticker reply buttons are hidden. */
  suppresses_join_notifications_replies -> bool:
    return (value & SUPPRESS_JOIN_NOTIFICATIONS_REPLIES) != 0

  /** Whether role subscription purchase and renewal notifications are suppressed. */
  suppresses_role_subscription_purchase_notifications -> bool:
    return (value & SUPPRESS_ROLE_SUBSCRIPTION_PURCHASE_NOTIFICATIONS) != 0

  /** Whether role subscription sticker reply buttons are hidden. */
  suppresses_role_subscription_purchase_notification_replies -> bool:
    return (value & SUPPRESS_ROLE_SUBSCRIPTION_PURCHASE_NOTIFICATION_REPLIES) != 0

class Guild:
  /** Members receive notifications for all messages by default. */
  static DEFAULT_MESSAGE_NOTIFICATIONS_ALL_MESSAGES ::= 0
  /** Members receive notifications only for messages that @mention them. */
  static DEFAULT_MESSAGE_NOTIFICATIONS_ONLY_MENTIONS ::= 1

  /** Media content is not scanned. */
  static EXPLICIT_CONTENT_FILTER_DISABLED ::= 0
  /** Media content sent by members without a role is scanned. */
  static EXPLICIT_CONTENT_FILTER_MEMBERS_WITHOUT_ROLES ::= 1
  /** Media content sent by all members is scanned. */
  static EXPLICIT_CONTENT_FILTER_ALL_MEMBERS ::= 2

  /** The guild has no MFA/2FA requirement for moderation actions. */
  static MFA_LEVEL_NONE ::= 0
  /** The guild has a 2FA requirement for moderation actions. */
  static MFA_LEVEL_ELEVATED ::= 1

  /** Unrestricted. */
  static VERIFICATION_LEVEL_NONE ::= 0
  /** Must have a verified email on their account. */
  static VERIFICATION_LEVEL_LOW ::= 1
  /** Must be registered on Discord for longer than 5 minutes. */
  static VERIFICATION_LEVEL_MEDIUM ::= 2
  /** Must be a member of the server for longer than 10 minutes. */
  static VERIFICATION_LEVEL_HIGH ::= 3
  /** Must have a verified phone number. */
  static VERIFICATION_LEVEL_VERY_HIGH ::= 4

  static NSFW_LEVEL_DEFAULT ::= 0
  static NSFW_LEVEL_EXPLICIT ::= 1
  static NSFW_LEVEL_SAFE ::= 2
  static NSFW_LEVEL_AGE_RESTRICTED ::= 3

  /** The guild has not unlocked any server boost perks. */
  static PREMIUM_TIER_NONE ::= 0
  /** The guild has unlocked server boost level 1 perks. */
  static PREMIUM_TIER_1 ::= 1
  /** The guild has unlocked server boost level 2 perks. */
  static PREMIUM_TIER_2 ::= 2
  /** The guild has unlocked server boost level 3 perks. */
  static PREMIUM_TIER_3 ::= 3

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
  icon_hash/string?

  /** The guild's splash hash. */
  splash/string?

  /** The guild's discovery splash hash. */
  discovery_splash/string?

  /** Whether the user is the owner of the guild. */
  is_owner/bool?

  /** The id of the guild owner. */
  owner_id/string?

  /** The total permissions for the user in the guild (excludes overwrites). */
  permissions/string?

  /** The voice region id for the guild. */
  region/string?

  /** The id of the afk channel. */
  afk_channel_id/string?

  /** The afk timeout in seconds. */
  afk_timeout/int?

  /** Whether the server widget is enabled. */
  is_widget_enabled/bool?

  /** The id of the channel where the server widget will generate an invite to. */
  widget_channel_id/string?

  /**
  The verification level required for the guild.
  One of:
  - $VERIFICATION_LEVEL_NONE
  - $VERIFICATION_LEVEL_LOW
  - $VERIFICATION_LEVEL_MEDIUM
  - $VERIFICATION_LEVEL_HIGH
  - $VERIFICATION_LEVEL_VERY_HIGH
  */
  verification_level/int?

  /**
  The default message notifications level.
  Either $DEFAULT_MESSAGE_NOTIFICATIONS_ALL_MESSAGES or $DEFAULT_MESSAGE_NOTIFICATIONS_ONLY_MENTIONS.
  */
  default_message_notifications/int?

  /**
  The explicit content filter level.
  One of:
  - $EXPLICIT_CONTENT_FILTER_DISABLED
  - $EXPLICIT_CONTENT_FILTER_MEMBERS_WITHOUT_ROLES
  - $EXPLICIT_CONTENT_FILTER_ALL_MEMBERS
  */
  explicit_content_filter/int?

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
  Either $MFA_LEVEL_NONE or $MFA_LEVEL_ELEVATED.
  */
  mfa_level/int?

  /** The id of the application that created the guild. */
  application_id/string?

  /** The id of the channel where guild notices such as welcome messages and boost events are posted. */
  system_channel_id/string?

  /** The system channel flags. */
  system_channel_flags_value/int?

  /** The id of the channel where Community guilds can display rules and/or guidelines. */
  rules_channel_id/string?

  /**
  The maximum number of presences for the guild.
  Null is always returned, apart from the largest of guilds.
  */
  max_presences/int?

  /** The maximum number of members for the guild. */
  max_members/int?

  /** The vanity url code for the guild. */
  vanity_url_code/string?

  /** The description of the guild. */
  description/string?

  /** The banner hash. */
  banner/string?

  /**
  The premium tier (Server Boost level).
  One of:
  - $PREMIUM_TIER_NONE
  - $PREMIUM_TIER_1
  - $PREMIUM_TIER_2
  - $PREMIUM_TIER_3
  */
  premium_tier/int?

  /** The number of boosts this guild currently has. */
  premium_subscription_count/int?

  /** The preferred locale of a Community guild; used in server discovery and notices from Discord, and sent in interactions; defaults to "en-US".
  */
  preferred_locale/string?

  /** The id of the channel where admins and moderators of Community guilds receive notices from Discord. */
  public_updates_channel_id/string?

  /**
  The maximum amount of users in a video channel.
  Returned when in the template object.
  */
  max_video_channel_users/int?

  /**
  Approximate number of members in this guild.
  Returned from the GET /guilds/<id> endpoint when with_counts is true.
  */
  approximate_member_count/int?

  /**
  Approximate number of non-offline members in this guild.
  Returned from the GET /guilds/<id> endpoint when with_counts is true.
  */
  approximate_presence_count/int?

  /** The welcome screen of a Community guild, shown to new members, returned in an Invite's guild object. */
  welcome_screen/WelcomeScreen?

  /**
  The guild NSFW level.
  One of:
  - $NSFW_LEVEL_DEFAULT
  - $NSFW_LEVEL_EXPLICIT
  - $NSFW_LEVEL_SAFE
  - $NSFW_LEVEL_AGE_RESTRICTED
  */
  nsfw_level/int?

  /**
  The custom guild stickers.
  A list of $Sticker objects.
  */
  stickers/List?

  /** Whether the guild has the boost progress bar enabled. */
  premium_progress_bar_enabled/bool?

  /**
  Whether this guild is available.
  A partial guild, or unavailable guild, is a guild whose information
    has not been provided.
  Unavailable guilds only have their $id set.
  */
  is_available/bool

  constructor.from_json json/Map:
    is_available = not json.contains "unavailable"
    id = json["id"]
    name = json.get "name"
    icon = json.get "icon"
    icon_hash = json.get "icon_hash"
    splash = json.get "splash"
    discovery_splash = json.get "discovery_splash"
    is_owner = json.get "owner"
    owner_id = json.get "owner_id"
    permissions = json.get "permissions"
    region = json.get "region"
    afk_channel_id = json.get "afk_channel_id"
    afk_timeout = json.get "afk_timeout"
    is_widget_enabled = json.get "widget_enabled"
    widget_channel_id = json.get "widget_channel_id"
    verification_level = json.get "verification_level"
    default_message_notifications = json.get "default_message_notifications"
    explicit_content_filter = json.get "explicit_content_filter"
    roles = json.get "roles"
    emojis = json.get "emojis"
    features = json.get "features"
    mfa_level = json.get "mfa_level"
    application_id = json.get "application_id"
    system_channel_id = json.get "system_channel_id"
    system_channel_flags_value = json.get "system_channel_flags"
    rules_channel_id = json.get "rules_channel_id"
    max_presences = json.get "max_presences"
    max_members = json.get "max_members"
    vanity_url_code = json.get "vanity_url_code"
    description = json.get "description"
    banner = json.get "banner"
    premium_tier = json.get "premium_tier"
    premium_subscription_count = json.get "premium_subscription_count"
    preferred_locale = json.get "preferred_locale"
    public_updates_channel_id = json.get "public_updates_channel_id"
    max_video_channel_users = json.get "max_video_channel_users"
    approximate_member_count = json.get "approximate_member_count"
    approximate_presence_count = json.get "approximate_presence_count"
    welcome_screen_entry := json.get "welcome_screen"
    if welcome_screen_entry:
      welcome_screen = WelcomeScreen.from_json welcome_screen_entry
    else:
      welcome_screen = null
    nsfw_level = json.get "nsfw_level"
    stickers_entry := json.get "stickers"
    if stickers_entry:
      stickers = stickers_entry.map: Sticker.from_json it
    else:
      stickers = []
    premium_progress_bar_enabled = json.get "premium_progress_bar_enabled"

  system_channel_flags -> SystemChannelFlags:
    return SystemChannelFlags system_channel_flags_value

class Role:
  /** The role's id. */
  id/string

  /** The role's name. */
  name/string

  /** The role's color. */
  color/int

  /** Whether the role is hoisted. */
  is_hoisted/bool

  /** The role's icon hash. */
  icon/string?

  /** The role's unicode emoji. */
  unicode_emoji/string?

  /** The role's position. */
  position/int

  /** The role's permissions. */
  permissions/string

  /** Whether the role is managed. */
  is_managed/bool

  /** Whether the role is mentionable. */
  is_mentionable/bool

  /** The role's tags. */
  tags/RoleTags?

  constructor.from_json json/Map:
    id = json["id"]
    name = json["name"]
    color = json["color"]
    is_hoisted = json["hoist"]
    icon = json.get "icon"
    unicode_emoji = json.get "unicode_emoji"
    position = json["position"]
    permissions = json["permissions"]
    is_managed = json["managed"]
    is_mentionable = json["mentionable"]
    tags_json := json.get "tags"
    if tags_json:
      tags = RoleTags.from_json tags_json
    else:
      tags = null

class RoleTags:
  /** The id of the bot this role belongs to. */
  bot_id/string?

  /** The id of the integration this role belongs to. */
  integration_id/string?

  /** Whether this is the guild's Booster role. */
  is_premium_subscriber/bool?

  /** The id of this role's subscription sku and listing. */
  subscription_listing_id/string?

  /** Whether this role is available for purchase. */
  is_available_for_purchase/bool?

  /** Whether this role is a guild's linked role. */
  is_guild_connections/bool?

  constructor.from_json json/Map:
    bot_id = json.get "bot_id"
    integration_id = json.get "integration_id"
    is_premium_subscriber = json.get "premium_subscriber"
    subscription_listing_id = json.get "subscription_listing_id"
    is_available_for_purchase = json.get "available_for_purchase"
    is_guild_connections = json.get "guild_connections"

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
  requires_colons/bool?

  /** Whether this emoji is managed. */
  is_managed/bool?

  /** Whether this emoji is animated. */
  is_animated/bool?

  /**
  Whether this emoji can be used.
  May be false due to loss of Server Boosts.
  */
  is_available/bool?

  constructor.from_json json/Map:
    id = json.get "id"
    name = json.get "name"
    roles = json.get "roles"
    user_entry := json.get "user"
    if user_entry:
      user = User.from_json user_entry
    else:
      user = null
    requires_colons = json.get "require_colons"
    is_managed = json.get "managed"
    is_animated = json.get "animated"
    is_available = json.get "available"

  stringify -> string:
    return "Emoji $name"

class WelcomeScreen:
  /** The server description shown in the welcome screen. */
  description/string?

  /**
  The channels shown in the welcome screen, up to 5.
  A list of $WelcomeScreenChannel objects.
  */
  welcome_channels/List

  constructor.from_json json/Map:
    description = json.get "description"
    welcome_channels = json["welcome_channels"].map: WelcomeScreenChannel.from_json it

class WelcomeScreenChannel:
  /** The channel's id. */
  channel_id/string

  /** The description shown for the channel. */
  description/string

  /** The emoji id, if the emoji is custom. */
  emoji_id/string?

  /** The emoji name if custom, the unicode character if standard, or null if no emoji is set. */
  emoji_name/string?

  constructor.from_json json/Map:
    channel_id = json["channel_id"]
    description = json["description"]
    emoji_id = json.get "emoji_id"
    emoji_name = json.get "emoji_name"

class Sticker:
  /**
  An official sticker in a pack.
  Part of Nitro or in a removed purchasable pack.
  */
  static TYPE_STANDARD ::= 1
  /** A sticker uploaded to a guild for the guild's members. */
  static TYPE_GUILD ::= 2

  /** A PNG sticker. */
  static FORMAT_TYPE_PNG ::= 1
  /** An APNG (animated PNG) sticker. */
  static FORMAT_TYPE_APNG ::= 2
  /** A Lottie (vector graphics animation) sticker. */
  static FORMAT_TYPE_LOTTIE ::= 3
  /** A GIF sticker. */
  static FORMAT_TYPE_GIF ::= 4

  /** The sticker's id. */
  id/string

  /** The id of the pack the sticker is from. */
  pack_id/string?

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

  Either $TYPE_STANDARD or $TYPE_GUILD.
  */
  type/int

  /**
  The sticker's format type.
  One of:
  - $FORMAT_TYPE_PNG
  - $FORMAT_TYPE_APNG
  - $FORMAT_TYPE_LOTTIE
  - $FORMAT_TYPE_GIF
  */
  format_type/int

  /**
  Whether this guild sticker can be used.
  May be false due to loss of Server Boosts.
  */
  is_available/bool?

  /** The id of the guild that owns this sticker. */
  guild_id/string?

  /** The user that uploaded the guild sticker. */
  user/User?

  /** The standard sticker's sort order within its pack. */
  sort_value/int?

  constructor.from_json json/Map:
    id = json["id"]
    pack_id = json.get "pack_id"
    name = json["name"]
    description = json.get "description"
    tags = json["tags"]
    asset = json.get "asset"
    type = json["type"]
    format_type = json["format_type"]
    is_available = json.get "available"
    guild_id = json.get "guild_id"
    user = json.get "user"
    sort_value = json.get "sort_value"

class Channel:
  /** A text channel within a server. */
  static TYPE_GUILD_TEXT ::= 0
  /** A direct message between users. */
  static TYPE_DM ::= 1
  /** A voice channel within a server. */
  static TYPE_GUILD_VOICE ::= 2
  /** A direct message between multiple users. */
  static TYPE_GROUP_DM ::= 3
  /** An organizational category that contains up to 50 channels. */
  static TYPE_GUILD_CATEGORY ::= 4
  /** A channel that users can follow and crosspost into their own server. */
  static TYPE_GUILD_ANNOUNCEMENT ::= 5
  /** A temporary sub-channel within a GUILD_ANNOUNCEMENT channel. */
  static TYPE_ANNOUNCEMENT_THREAD ::= 10
  /** A temporary sub-channel within a GUILD_TEXT or GUILD_FORUM channel. */
  static TYPE_PUBLIC_THREAD ::= 11
  /** A temporary sub-channel within a GUILD_TEXT channel that is only viewable by those invited and those with the MANAGE_THREADS permission. */
  static TYPE_PRIVATE_THREAD ::= 12
  /** A voice channel for hosting events with an audience. */
  static TYPE_GUILD_STAGE_VOICE ::= 13
  /** The channel in a hub containing the listed servers. */
  static TYPE_GUILD_DIRECTORY ::= 14
  /** Channel that can only contain threads. */
  static TYPE_GUILD_FORUM ::= 15

  /** Discord chooses the quality for optimal performance. */
  static VIDEO_QUALITY_MODE_AUTO ::= 1
  /** 720p. */
  static VIDEO_QUALITY_MODE_FULL ::= 2

  /** Sort forum posts by activity. */
  static SORT_ORDER_LATEST_ACTIVITY ::= 0
  /** Sort forum posts by creation date (from most recent to oldest). */
  static SORT_ORDER_CREATION_DATE ::= 1

  /** No default has been set for the form channel. */
  static LAYOUT_NOT_SET ::= 0
  /** Display posts as a list. */
  static LAYOUT_LIST_VIEW ::= 1
  /** Display posts as a collection of tiles. */
  static LAYOUT_GALLERY_VIEW ::= 2

  /** The id of this channel. */
  id/string

  /**
  The type of channel.
  One of:
  - $TYPE_GUILD_TEXT
  - $TYPE_DM
  - $TYPE_GUILD_VOICE
  - $TYPE_GROUP_DM
  - $TYPE_GUILD_CATEGORY
  - $TYPE_GUILD_ANNOUNCEMENT
  - $TYPE_ANNOUNCEMENT_THREAD
  - $TYPE_PUBLIC_THREAD
  - $TYPE_PRIVATE_THREAD
  - $TYPE_GUILD_STAGE_VOICE
  - $TYPE_GUILD_DIRECTORY
  - $TYPE_GUILD_FORUM
  */
  type/int

  /**
  The id of the guild.
  May be missing for some channel objects received over gateway guild dispatches).
  */
  guild_id/string?

  /** Sorting position of the channel. */
  position/int?

  /**
  Explicit permission overwrites for members and roles.
  List of $Overwrite objects.
  */
  permission_overwrites/List?

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
  is_nsfw/bool?

  /**
  The id of the last message sent in this channel (or thread for GUILD_FORUM channels).
  May not point to an existing or valid message or thread.
  */
  last_message_id/string?

  /** The bitrate (in bits) of the voice channel. */
  bitrate/int?

  /** The user limit of the voice channel. */
  user_limit/int?

  /**
  Amount of seconds a user has to wait before sending another message.
  The value is in range 0-21600.
  Bots, as well as users with the permission manage_messages or manage_channel,
    are unaffected.
  */
  rate_limit_per_user/int?

  /**
  The recipients of the DM.
  A list of $User.
  */
  recipients/List?

  /** Icon hash of the group DM. */
  icon/string?

  /** Id of the creator of the group DM or thread. */
  owner_id/string?

  /** Application id of the group DM creator if it is bot-created. */
  application_id/string?

  /**
  Whether the channel is managed by an application via the gdm.join OAuth2 scope.
  Only for group DM channels.
  */
  is_managed/bool?

  /**
  The id of the parent category for a channelor (for guild channels), or
    the id of the text channel thing this thread was created (for threads).
  Each parent category can contain up to 50 channels.
  */
  parent_id/string?

  /**
  When the last pinned message was pinned.
  This may be null in events such as GUILD_CREATE when a message is not pinned.
  */
  last_pin_timestamp/string?

  /** Voice region id for the voice channel, automatic when set to null. */
  rtc_region/string?

  /**
  The camera video quality mode of the voice channel.
  If not present: $VIDEO_QUALITY_MODE_AUTO.

  One of:
  - $VIDEO_QUALITY_MODE_AUTO
  - $VIDEO_QUALITY_MODE_FULL
  */
  video_quality_mode/int?

  /**
  Number of messages in a thread.
  Does not include the initial message or deleted messages.
  */
  message_count/int?

  /**
  An approximate count of users in a thread.
  Stops counting at 50.
  */
  member_count/int?

  /** Thread-specific fields not needed by other channels. */
  thread_metadata/ThreadMetadata?

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
  default_auto_archive_duration/int?

  /**
  Computed permissions for the invoking user in the channel, including overwrites.
  Only included when part of the resolved data received on a slash command interaction.
  */
  permissions/string?

  /** Channel flags combined as a bitfield. */
  flags_value/int?

  /**
  The total number of messages sent in this thread.
  Similar to $message_count, but does not decrease when a message is deleted.
  */
  total_message_sent/int?

  /** The set of tags that can be used in a GUILD_FORUM channel. */
  available_tags/List?

  /**
  The IDs of the set of tags that have been applied to a thread in a GUILD_FORUM channel.
  */
  applied_tags/List?

  /**
  The emoji to show in the add reaction button on a thread in a GUILD_FORUM channel.
  */
  default_reaction/DefaultReaction?

  /**
  The initial rate_limit_per_user to set on newly created threads in a channel.
  This field is copied to the thread at creation time and does not live update.
  */
  default_thread_rate_limit_per_user/int?

  /**
  The default sort order type used to order posts in GUILD_FORUM channels.
  Defaults to null, which indicates a preferred sort order hasn't been set by a channel admin.
  One of $SORT_ORDER_LATEST_ACTIVITY or $SORT_ORDER_CREATION_DATE.
  */
  default_sort_order/int?

  /**
  The default forum layout view used to display posts in GUILD_FORUM channels.
  Defaults to $LAYOUT_NOT_SET, which indicates a layout view has
    not been set by a channel admin.
  One of:
  - $LAYOUT_NOT_SET
  - $LAYOUT_LIST_VIEW
  - $LAYOUT_GALLERY_VIEW
  */
  default_forum_layout/int?

  /**
  Set when the channel is created.
  Only used for events.
  */
  is_newly_created/bool?

  constructor.from_json json/Map:
    id = json["id"]
    type = json["type"]
    guild_id = json.get "guild_id"
    position = json.get "position"
    permission_overwrites_entry := json.get "permission_overwrites"
    if permission_overwrites_entry:
      permission_overwrites = permission_overwrites_entry.map: Overwrite.from_json it
    else:
      permission_overwrites = null
    name = json.get "name"
    topic = json.get "topic"
    is_nsfw = json.get "nsfw"
    last_message_id = json.get "last_message_id"
    bitrate = json.get "bitrate"
    user_limit = json.get "user_limit"
    rate_limit_per_user = json.get "rate_limit_per_user"
    recipients_entry := json.get "recipients"
    if recipients_entry:
      recipients = recipients_entry.map: User.from_json it
    else:
      recipients = null
    icon = json.get "icon"
    owner_id = json.get "owner_id"
    application_id = json.get "application_id"
    is_managed = json.get "is_managed"
    parent_id = json.get "parent_id"
    last_pin_timestamp = json.get "last_pin_timestamp"
    rtc_region = json.get "rtc_region"
    video_quality_mode = json.get "video_quality_mode"
    message_count = json.get "message_count"
    member_count = json.get "member_count"
    thread_metadata_entry := json.get "thread_metadata"
    if thread_metadata_entry:
      thread_metadata = ThreadMetadata.from_json thread_metadata_entry
    else:
      thread_metadata = null
    member_entry := json.get "member"
    if member_entry:
      member = ThreadMember.from_json member_entry
    else:
      member = null
    default_auto_archive_duration = json.get "default_auto_archive_duration"
    permissions = json.get "permissions"
    flags_value = json.get "flags"
    total_message_sent = json.get "total_message_sent"
    available_tags = json.get "available_tags"
    applied_tags = json.get "applied_tags"
    default_reaction_entry := json.get "default_reaction_emoji"
    if default_reaction_entry:
      default_reaction = DefaultReaction.from_json default_reaction_entry
    else:
      default_reaction = null
    default_thread_rate_limit_per_user = json.get "default_thread_rate_limit_per_user"
    default_sort_order = json.get "default_sort_order"
    default_forum_layout = json.get "default_forum_layout"
    is_newly_created = json.get "newly_created"
    thread_member_entry := json.get "thread_member"

  flags -> ChannelFlags:
    return ChannelFlags flags_value

  stringify -> string:
    if name: return "Channel $name ($id)"
    return "Channel $id"

class ChannelFlags:
  /** This thread is pinned to the top if its parent GUILD_FORM channel. */
  static PINNED ::= 1 << 1
  /**
  Whether a tag is required to be specified when creating a thread in a GUILD_FORUM channel.
  Tags are specified in the $Channel.applied_tags field.
  */
  static REQUIRE_TAG ::= 1 << 4

  value/int

  constructor .value:

  is_pinned -> bool:
    return (value & ChannelFlags.PINNED) != 0

  requires_tags -> bool:
    return (value & ChannelFlags.REQUIRE_TAG) != 0

class Overwrite:
  /** The overwrite is for a role. */
  static TYPE_ROLE ::= 0
  /** The overwrite is for a member. */
  static TYPE_MEMBER ::= 1

  /** The id of the role or user */
  id/string

  /**
  The type of the overwrite.
  Either $TYPE_ROLE or $TYPE_MEMBER.
  */
  type/int

  /** The allowed permissions. */
  allow/string

  /** The denied permissions. */
  deny/string

  constructor.from_json json/Map:
    id = json["id"]
    type = json["type"]
    allow = json["allow"]
    deny = json["deny"]

class ThreadMetadata:
  /** Whether the thread is archived. */
  is_archived/bool

  /**
  The duration in minutes to automatically archive the thread after recent activity.
  The thread will stop showing in the channel list after this duration of inactivity.
  Can be set to 60, 1440, 4320, or 10080.
  */
  auto_archive_duration/int

  /**
  The timestamp when the thread's archive status was last changed.
  An ISO8601 timestamp.
  */
  archive_timestamp_value/string

  /**
  Whether the thread is locked.
  When a thread is locked, only users with MANAGE_THREADS can unarchive it.
  */
  is_locked/bool

  /**
  Whether non-moderators can add other non-moderators to a thread.
  Only available on private threads.
  */
  is_invitable/bool?

  /**
  The timestamp when the thread was created.
  An ISO8601 timestamp.
  Only populated for threads created after 2022-01-09.
  */
  create_timestamp_value/string?

  constructor.from_json json/Map:
    is_archived = json["archived"]
    auto_archive_duration = json["auto_archive_duration"]
    archive_timestamp_value = json["archive_timestamp"]
    is_locked = json["locked"]
    is_invitable = json.get "invitable"
    create_timestamp_value = json.get "create_timestamp"

  archive_timestamp -> Time?:
    return archive_timestamp_value and parse_iso8601_ archive_timestamp_value

  create_timestamp -> Time?:
    return create_timestamp_value and parse_iso8601_ create_timestamp_value

class ThreadMember:
  /** The id of the thread. */
  id/string

  /** The id of the user. */
  user_id/string?

  /** The timestamp when the user last joined the thread. */
  join_timestamp_value/string

  /** Any user-thread settings, currently only used for notifications. */
  flags/int

  /**
  Additional information about the user.
  */
  member/GuildMember?

  constructor.from_json json/Map:
    id = json["id"]
    user_id = json.get "user_id"
    join_timestamp_value = json["join_timestamp"]
    flags = json["flags"]
    member_entry := json.get "member"
    if member_entry:
      member = GuildMember.from_json member_entry
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
  joined_at_value/string

  /** When the user started boosting the guild. */
  premium_since_value/string?

  /** Whether the user is deafened in voice channels. */
  is_deaf/bool

  /** Whether the user is muted in voice channels. */
  is_mute/bool

  /** Guild member flags represented as a bit set. */
  flags_value/int

  /**
  Whether the user has not yet passed the guild's Membership Screening requirements.
  */
  is_pending/bool?

  /** Total permissions of the member in the channel, including overwrites. */
  permissions/string?

  /**
  When the user's timeout will expire and the user will be able to communicate in the guild again.
  Null or a time in the past if the user is not timed out.
  */
  communication_disabled_until_value/string?

  constructor.from_json json/Map:
    user_entry := json.get "user"
    if user_entry and not user_entry.is_empty:
      user = User.from_json user_entry
    else:
      user = null
    nick = json.get "nick"
    avatar = json.get "avatar"
    roles = json["roles"]
    joined_at_value = json["joined_at"]
    premium_since_value = json.get "premium_since"
    is_deaf = json["deaf"]
    is_mute = json["mute"]
    flags_value = json.get "flags"
    is_pending = json.get "pending"
    permissions = json.get "permissions"
    communication_disabled_until_value = json.get "communication_disabled_until"

  /** When the user joined the guild. */
  joined_at -> Time:
    return parse_iso8601_ joined_at_value

  /** When the user started boosting the guild. */
  premium_since -> Time?:
    return premium_since_value and parse_iso8601_ premium_since_value

  /**
  When the user's timeout will expire and the user will be able to communicate in the guild again.
  Null or a time in the past if the user is not timed out.
  */
  communication_disabled_until -> Time?:
    return communication_disabled_until_value and parse_iso8601_ communication_disabled_until_value

  /** Guild member flags. */
  flags -> GuildMemberFlags:
    return GuildMemberFlags flags_value

class GuildMemberFlags:
  /** Member has left and rejoined the guild. */
  static DID_REJOIN ::= 1 << 0
  /** Member has completed onboarding. */
  static COMPLETED_ONBOARDING ::= 1 << 1
  /** Member is exempt from guild verification requirements. */
  static BYPASSES_VERIFICATION ::= 1 << 2
  /** Member has started onboarding. */
  static STARTED_ONBOARDING ::= 1 << 3

  value/int

  constructor .value:

  /** Whether the member has left and rejoined the guild. */
  did_rejoin -> bool:
    return (value & DID_REJOIN) != 0

  /** Whether the member has completed onboarding. */
  completed_onboarding -> bool:
    return (value & COMPLETED_ONBOARDING) != 0

  /** Whether the member is exempt from guild verification requirements. */
  bypasses_verification -> bool:
    return (value & BYPASSES_VERIFICATION) != 0

  /** Whether the member has started onboarding. */
  started_onboarding -> bool:
    return (value & STARTED_ONBOARDING) != 0

/**
An object that specifies the emoji to use as the default way to react
  to a forum post.

Exactly one of $emoji_id and $emoji_name must be set.
*/
class DefaultReaction:
  /** The id of a guild's custom emoji. */
  emoji_id/string?

  /** The unicode character of the emoji. */
  emoji_name/string?

  constructor.from_json json/Map:
    emoji_id = json.get "emoji_id"
    emoji_name = json.get "emoji_name"

/**
Represents a message sent in a channel within Discord.
*/
class Message:
  static TYPE_DEFAULT ::= 0
  static TYPE_RECIPIENT_ADD ::= 1
  static TYPE_RECIPIENT_REMOVE ::= 2
  static TYPE_CALL ::= 3
  static TYPE_CHANNEL_NAME_CHANGE ::= 4
  static TYPE_CHANNEL_ICON_CHANGE ::= 5
  static TYPE_CHANNEL_PINNED_MESSAGE ::= 6
  static TYPE_USER_JOIN ::= 7
  static TYPE_GUILD_BOOST ::= 8
  static TYPE_GUILD_BOOST_TIER_1 ::= 9
  static TYPE_GUILD_BOOST_TIER_2 ::= 10
  static TYPE_GUILD_BOOST_TIER_3 ::= 11
  static TYPE_CHANNEL_FOLLOW_ADD ::= 12
  static TYPE_GUILD_DISCOVERY_DISQUALIFIED ::= 14
  static TYPE_GUILD_DISCOVERY_REQUALIFIED ::= 15
  static TYPE_GUILD_DISCOVERY_GRACE_PERIOD_INITIAL_WARNING ::= 16
  static TYPE_GUILD_DISCOVERY_GRACE_PERIOD_FINAL_WARNING ::= 17
  static TYPE_THREAD_CREATED ::= 18
  static TYPE_REPLY ::= 19
  static TYPE_CHAT_INPUT_COMMAND ::= 20
  static TYPE_THREAD_STARTER_MESSAGE ::= 21
  static TYPE_GUILD_INVITE_REMINDER ::= 22
  static TYPE_CONTEXT_MENU_COMMAND ::= 23
  static TYPE_AUTO_MODERATION_ACTION ::= 24
  static TYPE_ROLE_SUBSCRIPTION_PURCHASE ::= 25
  static TYPE_INTERACTION_PREMIUM_UPSELL ::= 26
  static TYPE_STAGE_START ::= 27
  static TYPE_STAGE_END ::= 28
  static TYPE_STAGE_SPEAKER ::= 29
  static TYPE_STAGE_TOPIC ::= 31
  static TYPE_GUILD_APPLICATION_PREMIUM_SUBSCRIPTION ::= 32

  /** The id of the message. */
  id/string

  /** The id of the channel the message was sent in. */
  channel_id/string

  /**
  The author of this message.
  If $webhook_id is null then this field is a $User, otherwise a $WebhookUser.
  */
  author/Author?

  /**
  The content of the message.
  Empty if the app has not configured (or hasn't been approved for) the
    $Gateway.INTENT_GUILD_MESSAGE_CONTENT privileged intent.
  */
  content/string

  /** When this message was sent. */
  timestamp_value/string

  /** When this message was edited (or null if never). */
  edited_timestamp_value/string?

  /** Whether this was a TTS message. */
  is_tts/bool

  /** Whether this message mentions everyone. */
  mentions_everyone/bool

  /**
  Users specifically mentioned in the message.
  A list of $User objects.
  */
  mentions/List

  /**
  Roles specifically mentioned in this message.
  A list of role object ids.
  */
  mention_roles/List?

  /**
  Channels specifically mentioned in this message.
  A list of $ChannelMention objects.

  Not all channel mentions in a message appear in this field. Only textual
    channels that are visible to everyone in a lurkable guild are included.
  Only crossposted messages (via Channel Following) currently include
    this field at all. If no mentions in the message meet these requirements,
    this field is null.
  */
  mention_channels/List?

  /**
  Attached files.
  A list of $Attachment objects.

  Empty if the app has not configured (or hasn't been approved for) the
    $Gateway.INTENT_GUILD_MESSAGE_CONTENT privileged intent.
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
  is_pinned/bool

  /**
  If the message is generated by a webhook, this is the webhook's id.
  */
  webhook_id/string?

  /**
  The type of message.
  See $TYPE_DEFAULT and other TYPE constants.
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
  application_id/string?

  /**
  Data showing the source of a crosspost, channel follow add, pin, or reply message.
  */
  message_reference/MessageReference?

  /**
  Message flags combined as a bitfield.
  */
  flags_value/int?

  /**
  The message associated with the message_reference.

  Only returned for type $TYPE_REPLY or $TYPE_THREAD_STARTER_MESSAGE.
  If the message is a reply but the referenced_message is missing, the
    backend did not attempt to fetch that message, so its state is unknown.
  */
  referenced_message/Message?

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
    $Gateway.INTENT_GUILD_MESSAGE_CONTENT privileged intent.
  A list of $Component objects.
  */
  components/List?

  /**
  Sent if the message contains stickers.
  A list of $StickerItem objects.
  */
  sticker_items/List?

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
  role_subscription_data/RoleSubscriptionData?

  /** The guild id of the message. */
  guild_id/string?

  /** The (partial) guild member object of the message's author. */
  member/GuildMember?

  constructor.from_json json/Map:
    id = json["id"]
    channel_id = json["channel_id"]
    if json.get "webhook_id":
      author = WebhookUser.from_json json
    else:
      author_entry := json.get "author"
      if author_entry:
        author = User.from_json author_entry
    content = json["content"]
    timestamp_value = json["timestamp"]
    edited_timestamp_value = json.get "edited_timestamp"
    is_tts = json["tts"]
    mentions_everyone = json["mention_everyone"]
    mentions = json["mentions"].map: User.from_json it
    mention_roles = json.get "mention_roles"
    mention_channels_entry := json.get "mention_channels"
    if mention_channels_entry:
      mention_channels = mention_channels_entry.map: ChannelMention.from_json it
    else:
      mention_channels = null
    attachments = json["attachments"].map: Attachment.from_json it
    embeds = json["embeds"].map: Embed.from_json it
    reactions_entry := json.get "reactions"
    if reactions_entry:
      reactions = reactions_entry.map: Reaction.from_json it
    else:
      reactions = null
    nonce = json.get "nonce"
    is_pinned = json["pinned"]
    webhook_id = json.get "webhook_id"
    type = json["type"]
    activity_entry := json.get "activity"
    if activity_entry:
      activity = MessageActivity.from_json activity_entry
    else:
      activity = null
    application_entry := json.get "application"
    if application_entry:
      application = Application.from_json application_entry
    else:
      application = null
    application_id = json.get "application_id"
    message_reference_entry := json.get "message_reference"
    if message_reference_entry:
      message_reference = MessageReference.from_json message_reference_entry
    else:
      message_reference = null
    flags_value = json.get "flags"
    referenced_message_entry := json.get "referenced_message"
    if referenced_message_entry:
      referenced_message = Message.from_json referenced_message_entry
    else:
      referenced_message = null
    interaction_entry := json.get "interaction"
    if interaction_entry:
      interaction = MessageInteraction.from_json interaction_entry
    else:
      interaction = null
    thread_entry := json.get "thread"
    if thread_entry:
      thread = Channel.from_json thread_entry
    else:
      thread = null
    components_entry := json.get "components"
    if components_entry:
      components = components_entry.map: Component.from_json it
    else:
      components = null
    sticker_items_entry := json.get "sticker_items"
    if sticker_items_entry:
      sticker_items = sticker_items_entry.map: StickerItem.from_json it
    else:
      sticker_items = null
    position = json.get "position"
    role_subscription_data_entry := json.get "role_subscription_data"
    if role_subscription_data_entry:
      role_subscription_data = RoleSubscriptionData.from_json role_subscription_data_entry
    else:
      role_subscription_data = null
    if json.get "guild_id":
      guild_id = json["guild_id"]
    else:
      guild_id = null
    member_entry := json.get "member"
    if member_entry:
      member = GuildMember.from_json member_entry
    else:
      member = null

  flags -> MessageFlags?:
    if flags_value == null: return null
    return MessageFlags flags_value

  timestamp -> Time:
    return parse_iso8601_ timestamp_value

  edited_timestamp -> Time?:
    if not edited_timestamp_value: return null
    return parse_iso8601_ edited_timestamp_value

  stringify -> string:
    return "$author.username: $content"

class MessageFlags:
  /** This message has been published to subscribed channels (via Channel Following). */
  static CROSSPOSTED ::= 1 << 0
  /** This message originated from a message in another channel (via Channel Following). */
  static IS_CROSSPOST ::= 1 << 1
  /** Do not include any embeds when serializing this message. */
  static SUPPRESS_EMBEDS ::= 1 << 2
  /** The source message for this crosspost has been deleted (via Channel Following). */
  static SOURCE_MESSAGE_DELETED ::= 1 << 3
  /** This message came from the urgent message system. */
  static URGENT ::= 1 << 4
  /** This message has an associated thread, with the same id as the message. */
  static HAS_THREAD ::= 1 << 5
  /** This message is only visible to the user who invoked the Interaction. */
  static EPHEMERAL ::= 1 << 6
  /** This message is an Interaction Response and the bot is "thinking". */
  static LOADING ::= 1 << 7
  /** This message failed to mention some roles and add their members to the thread. */
  static FAILED_TO_MENTION_SOME_ROLES_IN_THREAD ::= 1 << 8
  /** This message will not trigger push and desktop notifications. */
  static SUPPRESS_NOTIFICATIONS ::= 1 << 12

  value/int

  constructor .value:

  /** Whether this message has been published to subscribed channels (via Channel Following). */
  crossposted -> bool:
    return (value & MessageFlags.CROSSPOSTED) != 0

  /** Whether this message originated from a message in another channel (via Channel Following). */
  is_crosspost -> bool:
    return (value & MessageFlags.IS_CROSSPOST) != 0

  /** Whether to not include any embeds when serializing this message. */
  should_suppress_embeds -> bool:
    return (value & MessageFlags.SUPPRESS_EMBEDS) != 0

  /** Whether the source message for this crosspost has been deleted (via Channel Following). */
  is_source_message_deleted -> bool:
    return (value & MessageFlags.SOURCE_MESSAGE_DELETED) != 0

  /** Whether this message came from the urgent message system. */
  is_urgent -> bool:
    return (value & MessageFlags.URGENT) != 0

  /** Whether this message has an associated thread, with the same id as the message. */
  has_thread -> bool:
    return (value & MessageFlags.HAS_THREAD) != 0

  /** Whether this message is only visible to the user who invoked the Interaction. */
  is_ephemeral -> bool:
    return (value & MessageFlags.EPHEMERAL) != 0

  /** Whether this message is an Interaction Response and the bot is "thinking". */
  is_loading -> bool:
    return (value & MessageFlags.LOADING) != 0

  /** Whether this message failed to mention some roles and add their members to the thread. */
  failed_to_mention_some_roles_in_thread -> bool:
    return (value & MessageFlags.FAILED_TO_MENTION_SOME_ROLES_IN_THREAD) != 0

  /** Whether this message will not trigger push and desktop notifications. */
  suppresses_notifications -> bool:
    return (value & MessageFlags.SUPPRESS_NOTIFICATIONS) != 0

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

  constructor.from_json json/Map:
    id = json["id"]
    username = json.get "username"
    avatar = json.get "avatar"

class ChannelMention:
  /** The id of the channel. */
  id/string

  /** The id of the guild containing the channel. */
  guild_id/string

  /**
  The type of channel.
  See $Channel.type.
  */
  type/int

  /** The name of the channel. */
  name/string

  constructor.from_json json/Map:
    id = json["id"]
    guild_id = json["guild_id"]
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
  content_type/string?

  /** The size of the file in bytes. */
  size/int

  /** The source url of the file. */
  url/string

  /** A proxied url of the file. */
  proxy_url/string

  /** The height of the file (if image). */
  height/int?

  /** The width of the file (if image). */
  width/int?

  /** Whether this attachment is ephemeral. */
  is_ephemeral/bool?

  constructor.from_json json/Map:
    id = json["id"]
    filename = json["filename"]
    description = json.get "description"
    content_type = json.get "content_type"
    size = json["size"]
    url = json["url"]
    proxy_url = json["proxy_url"]
    height = json.get "height"
    width = json.get "width"
    is_ephemeral = json.get "ephemeral"

class Embed:
  /** A generic embed rendered from embed attributes. */
  static TYPE_RICH ::= "rich"
  /** An image embed. */
  static TYPE_IMAGE ::= "image"
  /** A video embed. */
  static TYPE_VIDEO ::= "video"
  /** An animated gif image embed rendered as a video embed. */
  static TYPE_GIFV ::= "gifv"
  /** An article embed. */
  static TYPE_ARTICLE ::= "article"
  /** A link embed. */
  static TYPE_LINK ::= "link"

  /** The title of the embed. */
  title/string?

  /**
  The type of the embed.
  One of:
  - $TYPE_RICH
  - $TYPE_IMAGE
  - $TYPE_VIDEO
  - $TYPE_GIFV
  - $TYPE_ARTICLE
  - $TYPE_LINK
  */
  type/string?

  /** The description of the embed. */
  description/string?

  /** The url of the embed. */
  url/string?

  /** The timestamp of the embed content. */
  timestamp_value/string

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

  constructor.from_json json/Map:
    title = json.get "title"
    type = json.get "type"
    description = json.get "description"
    url = json.get "url"
    timestamp_value = json.get "timestamp"
    color = json.get "color"
    footer_entry := json.get "footer"
    if footer_entry:
      footer = EmbedFooter.from_json footer_entry
    else:
      footer = null
    image_entry := json.get "image"
    if image_entry:
      image = EmbedImage.from_json image_entry
    else:
      image = null
    thumbnail_entry := json.get "thumbnail"
    if thumbnail_entry:
      thumbnail = EmbedThumbnail.from_json thumbnail_entry
    else:
      thumbnail = null
    video_entry := json.get "video"
    if video_entry:
      video = EmbedVideo.from_json video_entry
    else:
      video = null
    provider_entry := json.get "provider"
    if provider_entry:
      provider = EmbedProvider.from_json provider_entry
    else:
      provider = null
    author_entry := json.get "author"
    if author_entry:
      author = EmbedAuthor.from_json author_entry
    else:
      author = null
    fields_entry := json.get "fields"
    if fields_entry:
      fields = fields_entry.map: EmbedField.from_json it
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
  icon_url/string?

  /** A proxied url of the author icon. */
  proxy_icon_url/string?

  constructor.from_json json/Map:
    name = json["name"]
    url = json.get "url"
    icon_url = json.get "icon_url"
    proxy_icon_url = json.get "proxy_icon_url"

class EmbedFooter:
  /** The text of the footer. */
  text/string

  /** The url of the footer icon. */
  icon_url/string?

  /** A proxied url of the footer icon. */
  proxy_icon_url/string?

  constructor.from_json json/Map:
    text = json["text"]
    icon_url = json.get "icon_url"
    proxy_icon_url = json.get "proxy_icon_url"

class EmbedImage:
  /** The source url of the image. */
  url/string

  /** A proxied url of the image. */
  proxy_url/string?

  /** The height of the image. */
  height/int?

  /** The width of the image. */
  width/int?

  constructor.from_json json/Map:
    url = json["url"]
    proxy_url = json.get "proxy_url"
    height = json.get "height"
    width = json.get "width"

class EmbedThumbnail:
  /** The source url of the thumbnail. */
  url/string

  /** A proxied url of the thumbnail. */
  proxy_url/string?

  /** The height of the thumbnail. */
  height/int?

  /** The width of the thumbnail. */
  width/int?

  constructor.from_json json/Map:
    url = json["url"]
    proxy_url = json.get "proxy_url"
    height = json.get "height"
    width = json.get "width"

class EmbedVideo:
  /** The source url of the video. */
  url/string

  /** A proxied url of the video. */
  proxy_url/string?

  /** The height of the video. */
  height/int?

  /** The width of the video. */
  width/int?

  constructor.from_json json/Map:
    url = json["url"]
    proxy_url = json.get "proxy_url"
    height = json.get "height"
    width = json.get "width"

class EmbedProvider:
  /** The name of the provider. */
  name/string?

  /** The url of the provider. */
  url/string?

  constructor.from_json json/Map:
    name = json.get "name"
    url = json.get "url"

class EmbedField:
  /** The name of the field. */
  name/string

  /** The value of the field. */
  value/string

  /** Whether or not this field should display inline. */
  inline/bool?

  constructor.from_json json/Map:
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

  constructor.from_json json/Map:
    count = json["count"]
    me = json["me"]
    emoji = Emoji.from_json json["emoji"]

class MessageActivity:
  static TYPE_JOIN ::= 1
  static TYPE_SPECTATE ::= 2
  static TYPE_LISTEN ::= 3
  static TYPE_JOIN_REQUEST ::= 5

  /**
  Type of message activity.
  One of:
  - $TYPE_JOIN
  - $TYPE_SPECTATE
  - $TYPE_LISTEN
  - $TYPE_JOIN_REQUEST
  */
  type/int

  /** Party id from a Rich Presence event. */
  party_id/string?

  constructor.from_json json/Map:
    type = json["type"]
    party_id = json.get "party_id"

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
  rpc_origins/List?

  /**
  Whether anyone (and not only the app owner) can join the app's bot
    to guilds.
  */
  bot_is_public/bool?

  /**
  Whether the app's bot will only join upon completion of the full oauth2
    code grant flow.
  */
  bot_requires_code_grant/bool?

  /** The url of the app's terms of service. */
  terms_of_service_url/string?

  /** The url of the app's privacy policy. */
  privacy_policy_url/string?

  /** Partial user object containing info on the owner of the application. */
  owner/User?

  /** The hex encoded key for verification in interactions and the GameSDK's GetTicket. */
  verify_key/string?

  /**
  The members of the team.

  If the application belongs to a team, this will be a list of the members of that team. */
  team/Team?

  /** The guild to which it has been linked. */
  guild_id/string?

  /** The id of the "Game SKU" that is created, if exists. */
  primary_sku_id/string?

  /** The URL slug that links to the store page. */
  slug/string?

  /** The application's default rich presence invite cover image hash. */
  cover_image/string?

  /** The application's public flags. */
  flags_value/int?

  /** Up to 5 tags describing the content and functionality of the application. */
  tags/List?

  /** Settings for the application's default in-app authorization link, if enabled. */
  install_params/InstallParams?

  /** The application's default custom authorization link, if enabled. */
  custom_install_url/string?

  /**
  The application's role connection verification entry point.
  When configured renders the app as a verification method in the guild role
    verification configuration.
  */
  role_connections_verification_url/string?

  constructor.from_json json/Map:
    id = json["id"]
    name = json.get "name"
    icon = json.get "icon"
    description = json.get "description"
    rpc_origins = json.get "rpc_origins"
    bot_is_public = json.get "bot_public"
    bot_requires_code_grant = json.get "bot_require_code_grant"
    terms_of_service_url = json.get "terms_of_service_url"
    privacy_policy_url = json.get "privacy_policy_url"
    owner_entry := json.get "owner"
    if owner_entry:
      owner = User.from_json owner_entry
    else:
      owner = null
    verify_key = json.get "verify_key"
    team_entry := json.get "team"
    if team_entry:
      team = Team.from_json team_entry
    else:
      team = null
    guild_id = json.get "guild_id"
    primary_sku_id = json.get "primary_sku_id"
    slug = json.get "slug"
    cover_image = json.get "cover_image"
    flags_value = json.get "flags"
    tags = json.get "tags"
    install_params_entry := json.get "install_params"
    if install_params_entry:
      install_params = InstallParams.from_json install_params_entry
    else:
      install_params = null
    custom_install_url = json.get "custom_install_url"
    role_connections_verification_url = json.get "role_connections_verification_url"

class Team:
  /** The unique id of the team. */
  id/string

  /** A hash of the image of the team's icon. */
  icon/string?

  /** The name of the team. */
  name/string?

  /** The user id of the current team owner. */
  owner_user_id/string?

  /**
  The members of the team.
  A list of $TeamMember objects.
  */
  members/List

  constructor.from_json json/Map:
    id = json["id"]
    icon = json.get "icon"
    name = json.get "name"
    owner_user_id = json.get "owner_user_id"
    members = json["members"].map: TeamMember.from_json it

class TeamMember:
  static MEMBERSHIP_INVITED ::= 1
  static MEMBERSHIP_ACCEPTED ::= 2

  /**
  The user's membership state on the team.
  Either $MEMBERSHIP_INVITED or $MEMBERSHIP_ACCEPTED.
  */
  membership_state/int

  /**
  Permissions.
  Always equal to a list with a the single entry "*".
  */
  permissions/List

  /** The id of the parent team of which they are a member. */
  team_id/string

  /** The avatar, discriminator, id, and username of the user. */
  user/User

  constructor.from_json json/Map:
    membership_state = json["membership_state"]
    permissions = json["permissions"]
    team_id = json["team_id"]
    user = User.from_json json["user"]

class InstallParams:
  /** The scopes to add the application to the server with. */
  scopes/List

  /** The permissions to request for the bot role. */
  permissions/string

  constructor.from_json json/Map:
    scopes = json["scopes"]
    permissions = json["permissions"]

class MessageReference:
  /** The id of the originating message. */
  message_id/string?

  /** The id of the originating message's channel. */
  channel_id/string?

  /** The id of the originating message's guild. */
  guild_id/string?

  /**
  Whether to error if the referenced message doesn't exist.
  When sending, fails if the referenced message doesn't exist.
  If false, sends as a normal (non-reply) message.
  Default is true.
  */
  fail_if_not_exists/bool?

  constructor.from_json json/Map:
    message_id = json.get "message_id"
    channel_id = json.get "channel_id"
    guild_id = json.get "guild_id"
    fail_if_not_exists = json.get "fail_if_not_exists"

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

  constructor.from_json json/Map:
    id = json["id"]
    type = json["type"]
    name = json["name"]
    user = User.from_json json["user"]
    member_entry := json.get "member"
    if member_entry:
      member = GuildMember.from_json member_entry
    else:
      member = null

class Component:
  /** Container for other components. */
  static TYPE_ACTION_ROW ::= 1
  /** Button object. */
  static TYPE_BUTTON ::= 2
  /** Select menu for picking from defined text options. */
  static TYPE_STRING_SELECT ::= 3
  /** Text input object. */
  static TYPE_TEXT_INPUT ::= 4
  /** Select menu for users. */
  static TYPE_USER_SELECT ::= 5
  /** Select menu for roles. */
  static TYPE_ROLE_SELECT ::= 6
  /** Select menu for mentionables (users and roles). */
  static TYPE_MENTIONABLE_SELECT ::= 7
  /** Select menu for channels. */
  static TYPE_CHANNEL_SELECT ::= 8

  /** The type of the component. */
  type/int

  constructor.from_json json/Map:
    type := json["type"]
    if type == TYPE_ACTION_ROW:
      return ComponentActionRow.from_json json
    else if type == TYPE_BUTTON:
      return ComponentButton.from_json json
    else if type == TYPE_STRING_SELECT or
        type == TYPE_USER_SELECT or
        type == TYPE_ROLE_SELECT or
        type == TYPE_MENTIONABLE_SELECT or
        type == TYPE_CHANNEL_SELECT:
      return ComponentSelect.from_json json
    else if type == TYPE_TEXT_INPUT:
      return ComponentTextInput.from_json json
    else:
      throw "Unknown component type $type"

  constructor .type/int:

class ComponentActionRow extends Component:
  /** A list of subcomponents of type $Component. */
  components/List

  constructor.from_json json/Map:
    components = json["components"].map: Component.from_json it
    super json["type"]

class ComponentButton extends Component:
  /** The primary style. Color blurple. */
  static STYLE_PRIMARY ::= 1
  /** The secondary style. Color grey. */
  static STYLE_SECONDARY ::= 2
  /** The success style. Color green. */
  static STYLE_SUCCESS ::= 3
  /** The danger style. Color red. */
  static STYLE_DANGER ::= 4
  /** The link style. Color grey. Navigates to a URL. */
  static STYLE_LINK ::= 5

  /**
  The style of the button.
  One of $STYLE_PRIMARY, $STYLE_SECONDARY, $STYLE_SUCCESS, $STYLE_DANGER, or $STYLE_LINK.
  */
  style/int

  /** The text that appears on the button. */
  label/string?

  /** The emoji that appears on the button. */
  emoji/Emoji?

  /** The custom id of the button. */
  custom_id/string?

  /** The url of the button. */
  url/string?

  /** Whether the button is disabled. */
  is_disabled/bool?

  constructor.from_json json/Map:
    style = json["style"]
    label = json.get "label"
    emoji_entry := json.get "emoji"
    if emoji_entry:
      emoji = Emoji.from_json emoji_entry
    else:
      emoji = null
    custom_id = json.get "custom_id"
    url = json.get "url"
    is_disabled = json.get "disabled"
    super json["type"]

class ComponentSelect extends Component:
  /**
  The custom id of the select menu.
  Max 100 characters.
  */
  custom_id/string

  /**
  The options of the select menu.
  Only applicable (and required) for string selects (type $Component.TYPE_STRING_SELECT).
  A list of $SelectOption.
  */
  options/List?

  /**
  The channel types to include in the channel select component.
  Only applicable for channel selects (type $Component.TYPE_CHANNEL_SELECT).
  See $Channel.type.
  */
  channel_types/List?

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
  min_values/int?

  /**
  The maximum number of items that can be chosen.
  Defaults to 1.
  Max 25.
  */
  max_values/int?

  /**
  Whether the select menu is disabled.
  Defaults to false.
  */
  is_disabled/bool?

  constructor.from_json json/Map:
    custom_id = json["custom_id"]
    options_entry := json.get "options"
    if options_entry:
      options = options_entry.map: SelectOption.from_json it
    else:
      options = null
    channel_types = json.get "channel_types"
    placeholder = json.get "placeholder"
    min_values = json.get "min_values"
    max_values = json.get "max_values"
    is_disabled = json.get "disabled"
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
  is_default/bool?

  constructor.from_json json/Map:
    label = json["label"]
    value = json["value"]
    description = json.get "description"
    emoji_entry := json.get "emoji"
    if emoji_entry:
      emoji = Emoji.from_json emoji_entry
    else:
      emoji = null
    is_default = json.get "default"

class ComponentTextInput extends Component:
  /** Single-line input. */
  static STYLE_SHORT ::= 1
  /** Multi-line input. */
  static STYLE_PARAGRAPH ::= 2

  /** The developer-defined identifier for the input. */
  custom_id/string

  /**
  The text input style.
  Either $STYLE_SHORT or $STYLE_PARAGRAPH.
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
  min_length/int?

  /**
  The maximum input length for a text input.
  Min 1, max 4000.
  */
  max_length/int?

  /**
  Whether this component is required to be filled.
  Defaults to true.
  */
  is_required/bool?

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

  constructor.from_json json/Map:
    custom_id = json["custom_id"]
    style = json["style"]
    label = json["label"]
    min_length = json.get "min_length"
    max_length = json.get "max_length"
    is_required = json.get "required"
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
  See $Sticker.format_type.
  */
  format_type/int

  constructor.from_json json/Map:
    id = json["id"]
    name = json["name"]
    format_type = json["format_type"]

class RoleSubscriptionData:
  /** The id of the sku and listing that the user is subscribed to. */
  role_subscription_listing_id/string

  /** The name of the tier that the user is subscribed to. */
  tier_name/string

  /** The cumulative number of months that the user has been subscribed for. */
  total_months_subscribed/int

  /** Whether this notification is for a renewal rather than a new purchase. */
  is_renewal/bool

  constructor.from_json json/Map:
    role_subscription_listing_id = json["role_subscription_listing_id"]
    tier_name = json["tier_name"]
    total_months_subscribed = json["total_months_subscribed"]
    is_renewal = json["is_renewal"]

parse_iso8601_ str/string? -> Time:
  // TODO(florian): Improve core libraries to be able to parse these timestamps.
    is_utc := str.ends_with "Z" or str.ends_with "+00:00"
    str = str.trim --right "Z"
    str = str.trim --right "+00:00"
    parts ::= str.split "T"
    str_to_int ::= :int.parse it --on_error=: throw "Cannot parse $it as integer"
    if parts.size != 2: throw "Expected T to separate date and time"
    date_parts ::= (parts[0].split "-").map str_to_int
    if date_parts.size != 3: throw "Expected 3 segments separated by - for date"
    time_string_parts ::= parts[1].split ":"
    if time_string_parts.size != 3: throw "Expected 3 segments separated by : for time"
    if time_string_parts[2].contains ".":
      split := time_string_parts[2].split "."
      time_string_parts[2] = split[0]
      time_string_parts.add "$split[1]000000000"[..9]
    else:
      time_string_parts.add "0"
    time_parts := time_string_parts.map: int.parse it
    return Time.local_or_utc_
      date_parts[0]
      date_parts[1]
      date_parts[2]
      time_parts[0]
      time_parts[1]
      time_parts[2]
      --ms=0
      --us=0
      --ns=time_parts[3]
      --is_utc=is_utc
