// Copyright (C) 2023 Florian Loitsch.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the TESTS_LICENSE file.

import discord.model
import expect show *

main:
  test_user
  test_guild
  test_guild_member
  test_channel
  test_welcome_screen
  test_message
  test_emoji
  test_application
  test_components

test_user:
  EXAMPLE_USER := {
    "id": "80351110224678912",
    "username": "Nelly",
    "discriminator": "1337",
    "avatar": "8342729096ea3675442027381ff50dfe",
    "verified": true,
    "email": "nelly@discord.com",
    "flags": 64,
    "banner": "06c16474723fe537c283b8efa61a30c8",
    "accent_color": 16711680,
    "premium_type": 1,
    "public_flags": 64
  }
  user := model.User.from_json EXAMPLE_USER
  expect_equals "80351110224678912" user.id
  expect_equals "Nelly" user.username
  expect_equals "1337" user.discriminator
  expect_equals "8342729096ea3675442027381ff50dfe" user.avatar
  expect user.is_verified
  expect_equals "nelly@discord.com" user.email
  expect_equals 64 user.flags_value
  expect_equals "06c16474723fe537c283b8efa61a30c8" user.banner
  expect_equals 16711680 user.accent_color
  expect_equals 1 user.premium_type
  expect_equals 64 user.public_flags_value

test_guild:
  EXAMPLE_GUILD ::= {
    "id": "197038439483310086",
    "name": "Discord Testers",
    "icon": "f64c482b807da4f539cff778d174971c",
    "description": "The official place to report Discord Bugs!",
    "splash": null,
    "discovery_splash": null,
    "features": [
      "ANIMATED_ICON",
      "VERIFIED",
      "NEWS",
      "VANITY_URL",
      "DISCOVERABLE",
      "MORE_EMOJI",
      "INVITE_SPLASH",
      "BANNER",
      "COMMUNITY"
    ],
    "emojis": [],
    "banner": "9b6439a7de04f1d26af92f84ac9e1e4a",
    "owner_id": "73193882359173120",
    "application_id": null,
    "region": null,
    "afk_channel_id": null,
    "afk_timeout": 300,
    "system_channel_id": null,
    "widget_enabled": true,
    "widget_channel_id": null,
    "verification_level": 3,
    "roles": [],
    "default_message_notifications": 1,
    "mfa_level": 1,
    "explicit_content_filter": 2,
    "max_presences": 40000,
    "max_members": 250000,
    "vanity_url_code": "discord-testers",
    "premium_tier": 3,
    "premium_subscription_count": 33,
    "system_channel_flags": 0,
    "preferred_locale": "en-US",
    "rules_channel_id": "441688182833020939",
    "public_updates_channel_id": "281283303326089216"
  }

  guild := model.Guild.from_json EXAMPLE_GUILD
  expect guild.is_available
  expect_equals "197038439483310086" guild.id
  expect_equals "Discord Testers" guild.name
  expect_equals "f64c482b807da4f539cff778d174971c" guild.icon
  expect_equals "The official place to report Discord Bugs!" guild.description
  expect_null guild.splash
  expect_null guild.discovery_splash
  expect_equals ["ANIMATED_ICON", "VERIFIED", "NEWS", "VANITY_URL", "DISCOVERABLE", "MORE_EMOJI", "INVITE_SPLASH", "BANNER", "COMMUNITY"] guild.features
  expect_equals [] guild.emojis
  expect_equals "9b6439a7de04f1d26af92f84ac9e1e4a" guild.banner
  expect_equals "73193882359173120" guild.owner_id
  expect_null guild.application_id
  expect_null guild.region
  expect_null guild.afk_channel_id
  expect_equals 300 guild.afk_timeout
  expect_null guild.system_channel_id
  expect guild.is_widget_enabled
  expect_null guild.widget_channel_id
  expect_equals 3 guild.verification_level
  expect_equals [] guild.roles
  expect_equals 1 guild.default_message_notifications
  expect_equals 1 guild.mfa_level
  expect_equals 2 guild.explicit_content_filter
  expect_equals 40000 guild.max_presences
  expect_equals 250000 guild.max_members
  expect_equals "discord-testers" guild.vanity_url_code
  expect_equals 3 guild.premium_tier
  expect_equals 33 guild.premium_subscription_count
  expect_equals 0 guild.system_channel_flags_value
  expect_equals "en-US" guild.preferred_locale
  expect_equals "441688182833020939" guild.rules_channel_id
  expect_equals "281283303326089216" guild.public_updates_channel_id

  UNAVAILABLE_GUILD ::= {
    "id": "41771983423143937",
    "unavailable": true
  }
  guild = model.Guild.from_json UNAVAILABLE_GUILD
  expect_not guild.is_available
  expect_equals "41771983423143937" guild.id

test_guild_member:
  GUILD_MEMBER ::= {
    "user": {:},
    "nick": "NOT API SUPPORT",
    "avatar": null,
    "roles": [],
    "joined_at": "2015-04-26T06:26:56.936000+00:00",
    "deaf": false,
    "mute": false
  }
  guild_member := model.GuildMember.from_json GUILD_MEMBER
  expect_equals "NOT API SUPPORT" guild_member.nick
  expect_null guild_member.avatar
  expect_equals [] guild_member.roles
  expect_equals "2015-04-26T06:26:56.936000+00:00" guild_member.joined_at_value
  time := guild_member.joined_at
  expect_equals 2015 time.utc.year
  expect_equals 4 time.utc.month
  expect_equals 26 time.utc.day
  expect_equals 6 time.utc.h
  expect_equals 26 time.utc.m
  expect_equals 56 time.utc.s
  expect_equals 936_000_000 time.utc.ns
  expect_not guild_member.is_deaf
  expect_not guild_member.is_mute

test_channel:
  TEXT_CHANNEL ::= {
    "id": "41771983423143937",
    "guild_id": "41771983423143937",
    "name": "general",
    "type": 0,
    "position": 6,
    "permission_overwrites": [],
    "rate_limit_per_user": 2,
    "nsfw": true,
    "topic": "24/7 chat about how to gank Mike #2",
    "last_message_id": "155117677105512449",
    "parent_id": "399942396007890945",
    "default_auto_archive_duration": 60
  }
  channel := model.Channel.from_json TEXT_CHANNEL
  expect_equals "41771983423143937" channel.id
  expect_equals "41771983423143937" channel.guild_id
  expect_equals "general" channel.name
  expect_equals model.Channel.TYPE_GUILD_TEXT channel.type
  expect_equals 6 channel.position
  expect_equals [] channel.permission_overwrites
  expect_equals 2 channel.rate_limit_per_user
  expect channel.is_nsfw
  expect_equals "24/7 chat about how to gank Mike #2" channel.topic
  expect_equals "155117677105512449" channel.last_message_id
  expect_equals "399942396007890945" channel.parent_id
  expect_equals 60 channel.default_auto_archive_duration

  ANNOUNCEMENT_CHANNEL ::= {
    "id": "41771983423143937",
    "guild_id": "41771983423143937",
    "name": "important-news",
    "type": 5,
    "position": 6,
    "permission_overwrites": [],
    "nsfw": true,
    "topic": "Rumors about Half Life 3",
    "last_message_id": "155117677105512449",
    "parent_id": "399942396007890945",
    "default_auto_archive_duration": 60
  }
  channel = model.Channel.from_json ANNOUNCEMENT_CHANNEL
  expect_equals "41771983423143937" channel.id
  expect_equals "41771983423143937" channel.guild_id
  expect_equals "important-news" channel.name
  expect_equals model.Channel.TYPE_GUILD_ANNOUNCEMENT channel.type
  expect_equals 6 channel.position
  expect_equals [] channel.permission_overwrites
  expect channel.is_nsfw
  expect_equals "Rumors about Half Life 3" channel.topic
  expect_equals "155117677105512449" channel.last_message_id
  expect_equals "399942396007890945" channel.parent_id
  expect_equals 60 channel.default_auto_archive_duration

  VOICE_CHANNEL ::= {
    "id": "155101607195836416",
    "last_message_id": "174629835082649376",
    "type": 2,
    "name": "ROCKET CHEESE",
    "position": 5,
    "parent_id": null,
    "bitrate": 64000,
    "user_limit": 0,
    "rtc_region": null,
    "guild_id": "41771983423143937",
    "permission_overwrites": [],
    "rate_limit_per_user": 0,
    "nsfw": false,
  }
  channel = model.Channel.from_json VOICE_CHANNEL
  expect_equals "155101607195836416" channel.id
  expect_equals "174629835082649376" channel.last_message_id
  expect_equals model.Channel.TYPE_GUILD_VOICE channel.type
  expect_equals "ROCKET CHEESE" channel.name
  expect_equals 5 channel.position
  expect_null channel.parent_id
  expect_equals 64000 channel.bitrate
  expect_equals 0 channel.user_limit
  expect_null channel.rtc_region
  expect_equals "41771983423143937" channel.guild_id
  expect_equals [] channel.permission_overwrites
  expect_equals 0 channel.rate_limit_per_user
  expect_not channel.is_nsfw

  DM_CHANNEL ::= {
    "last_message_id": "3343820033257021450",
    "type": 1,
    "id": "319674150115610528",
    "recipients": [
      {
        "username": "test",
        "discriminator": "9999",
        "id": "82198898841029460",
        "avatar": "33ecab261d4681afa4d85a04691c4a01"
      }
    ]
  }
  channel = model.Channel.from_json DM_CHANNEL
  expect_equals "3343820033257021450" channel.last_message_id
  expect_equals model.Channel.TYPE_DM channel.type
  expect_equals "319674150115610528" channel.id
  expect_equals 1 channel.recipients.size
  user/model.User := channel.recipients[0]
  expect_equals "test" user.username
  expect_equals "9999" user.discriminator
  expect_equals "82198898841029460" user.id
  expect_equals "33ecab261d4681afa4d85a04691c4a01" user.avatar

test_welcome_screen:
  WELCOME_SCREEN ::= {
    "description": "Discord Developers is a place to learn about Discord's API, bots, and SDKs and integrations. This is NOT a general Discord support server.",
    "welcome_channels": [
      {
        "channel_id": "697138785317814292",
        "description": "Follow for official Discord API updates",
        "emoji_id": null,
        "emoji_name": "📡"
      },
      {
        "channel_id": "697236247739105340",
        "description": "Get help with Bot Verifications",
        "emoji_id": null,
        "emoji_name": "📸"
      },
      {
        "channel_id": "697489244649816084",
        "description": "Create amazing things with Discord's API",
        "emoji_id": null,
        "emoji_name": "🔬"
      },
      {
        "channel_id": "613425918748131338",
        "description": "Integrate Discord into your game",
        "emoji_id": null,
        "emoji_name": "🎮"
      },
      {
        "channel_id": "646517734150242346",
        "description": "Find more places to help you on your quest",
        "emoji_id": null,
        "emoji_name": "🔦"
      }
    ]
  }

  welcome_screen := model.WelcomeScreen.from_json WELCOME_SCREEN
  expect_equals "Discord Developers is a place to learn about Discord's API, bots, and SDKs and integrations. This is NOT a general Discord support server." welcome_screen.description
  expect_equals 5 welcome_screen.welcome_channels.size
  expect_equals "697138785317814292" welcome_screen.welcome_channels[0].channel_id
  expect_equals "Follow for official Discord API updates" welcome_screen.welcome_channels[0].description
  expect_null welcome_screen.welcome_channels[0].emoji_id
  expect_equals "📡" welcome_screen.welcome_channels[0].emoji_name
  expect_equals "697236247739105340" welcome_screen.welcome_channels[1].channel_id
  expect_equals "Get help with Bot Verifications" welcome_screen.welcome_channels[1].description
  expect_null welcome_screen.welcome_channels[1].emoji_id
  expect_equals "📸" welcome_screen.welcome_channels[1].emoji_name
  expect_equals "697489244649816084" welcome_screen.welcome_channels[2].channel_id
  expect_equals "Create amazing things with Discord's API" welcome_screen.welcome_channels[2].description
  expect_null welcome_screen.welcome_channels[2].emoji_id
  expect_equals "🔬" welcome_screen.welcome_channels[2].emoji_name
  expect_equals "613425918748131338" welcome_screen.welcome_channels[3].channel_id
  expect_equals "Integrate Discord into your game" welcome_screen.welcome_channels[3].description
  expect_null welcome_screen.welcome_channels[3].emoji_id
  expect_equals "🎮" welcome_screen.welcome_channels[3].emoji_name
  expect_equals "646517734150242346" welcome_screen.welcome_channels[4].channel_id
  expect_equals "Find more places to help you on your quest" welcome_screen.welcome_channels[4].description
  expect_null welcome_screen.welcome_channels[4].emoji_id
  expect_equals "🔦" welcome_screen.welcome_channels[4].emoji_name

test_message:
  MESSAGE1 ::= {
    "reactions": [
      {
        "count": 1,
        "me": false,
        "emoji": {
          "id": null,
          "name": "🔥"
        }
      }
    ],
    "attachments": [],
    "tts": false,
    "embeds": [],
    "timestamp": "2017-07-11T17:27:07.299000+00:00",
    "mention_everyone": false,
    "id": "334385199974967042",
    "pinned": false,
    "edited_timestamp": null,
    "author": {
      "username": "Mason",
      "discriminator": "9999",
      "id": "53908099506183680",
      "avatar": "a_bab14f271d565501444b2ca3be944b25"
    },
    "mention_roles": [],
    "content": "Supa Hot",
    "channel_id": "290926798999357250",
    "mentions": [],
    "type": 0
  }
  message := model.Message.from_json MESSAGE1
  expect_equals "Supa Hot" message.content
  expect_equals "334385199974967042" message.id
  expect_equals "290926798999357250" message.channel_id
  expect_equals model.Message.TYPE_DEFAULT message.type
  expect_equals "2017-07-11T17:27:07.299000+00:00" message.timestamp_value
  timestamp := message.timestamp
  expect_equals 2017 timestamp.utc.year
  expect_equals 7 timestamp.utc.month
  expect_equals 11 timestamp.utc.day
  expect_equals 17 timestamp.utc.h
  expect_equals 27 timestamp.utc.m
  expect_equals 7 timestamp.utc.s
  expect_equals 299_000_000 timestamp.utc.ns
  expect_not message.mentions_everyone
  expect_not message.is_pinned
  expect_not message.is_tts
  author := message.author
  expect author is model.User
  user := author as model.User
  expect_equals "Mason" user.username
  expect_equals "9999" user.discriminator
  expect_equals "53908099506183680" user.id
  expect_equals "a_bab14f271d565501444b2ca3be944b25" user.avatar
  expect_equals 1 message.reactions.size
  reaction/model.Reaction := message.reactions[0]
  expect_equals 1 reaction.count
  expect_not reaction.me
  emoji := reaction.emoji
  expect_equals "🔥" emoji.name
  expect_null emoji.id

  MESSAGE2 ::= {
    "reactions": [
      {
        "count": 1,
        "me": false,
        "emoji": {
          "id": null,
          "name": "🔥"
        }
      }
    ],
    "attachments": [],
    "tts": false,
    "embeds": [],
    "timestamp": "2017-07-11T17:27:07.299000+00:00",
    "mention_everyone": false,
    "id": "334385199974967042",
    "pinned": false,
    "edited_timestamp": null,
    "author": {
      "username": "Mason",
      "discriminator": "9999",
      "id": "53908099506183680",
      "avatar": "a_bab14f271d565501444b2ca3be944b25"
    },
    "mention_roles": [],
    "mention_channels": [
      {
        "id": "278325129692446722",
        "guild_id": "278325129692446720",
        "name": "big-news",
        "type": 5
      }
    ],
    "content": "Big news! In this <#278325129692446722> channel!",
    "channel_id": "290926798999357250",
    "mentions": [],
    "type": 0,
    "flags": 2,
    "message_reference": {
      "channel_id": "278325129692446722",
      "guild_id": "278325129692446720",
      "message_id": "306588351130107906"
    }
  }

  message = model.Message.from_json MESSAGE2
  expect_equals "Big news! In this <#278325129692446722> channel!" message.content
  expect_equals "334385199974967042" message.id
  expect_equals "290926798999357250" message.channel_id
  expect_equals model.Message.TYPE_DEFAULT message.type
  expect_equals "2017-07-11T17:27:07.299000+00:00" message.timestamp_value
  timestamp = message.timestamp
  expect_equals 2017 timestamp.utc.year
  expect_equals 7 timestamp.utc.month
  expect_equals 11 timestamp.utc.day
  expect_equals 17 timestamp.utc.h
  expect_equals 27 timestamp.utc.m
  expect_equals 7 timestamp.utc.s
  expect_equals 299_000_000 timestamp.utc.ns
  expect_not message.mentions_everyone
  expect_not message.is_pinned
  expect_not message.is_tts
  author = message.author
  expect author is model.User
  user = author as model.User
  expect_equals "Mason" user.username
  expect_equals "9999" user.discriminator
  expect_equals "53908099506183680" user.id
  expect_equals "a_bab14f271d565501444b2ca3be944b25" user.avatar
  expect_equals 1 message.reactions.size
  reaction = message.reactions[0]
  expect_equals 1 reaction.count
  expect_not reaction.me
  emoji = reaction.emoji
  expect_equals "🔥" emoji.name
  expect_null emoji.id
  expect_equals 1 message.mention_channels.size
  channel/model.ChannelMention := message.mention_channels[0]
  expect_equals "278325129692446722" channel.id
  expect_equals "278325129692446720" channel.guild_id
  expect_equals "big-news" channel.name
  expect_equals model.Channel.TYPE_GUILD_ANNOUNCEMENT channel.type

test_emoji:
  EMOJI_PREMIUM ::= {
    "id": "41771983429993937",
    "name": "LUL",
    "roles": ["41771983429993000", "41771983429993111"],
    "user": {
      "username": "Luigi",
      "discriminator": "0002",
      "id": "96008815106887111",
      "avatar": "5500909a3274e1812beb4e8de6631111",
      "public_flags": 131328
    },
    "require_colons": true,
    "managed": false,
    "animated": false
  }
  emoji := model.Emoji.from_json EMOJI_PREMIUM
  expect_equals "41771983429993937" emoji.id
  expect_equals "LUL" emoji.name
  expect_equals 2 emoji.roles.size
  expect_equals "41771983429993000" emoji.roles[0]
  expect_equals "41771983429993111" emoji.roles[1]
  expect_equals 131328 emoji.user.public_flags_value
  flags := emoji.user.public_flags
  // TODO(florian): test flags.
  expect emoji.requires_colons
  expect_not emoji.is_managed
  expect_not emoji.is_animated

  EMOJI_STANDARD ::= {
    "id": null,
    "name": "🔥",
  }
  emoji = model.Emoji.from_json EMOJI_STANDARD
  expect_null emoji.id
  expect_equals "🔥" emoji.name

  EMOJI_CUSTOM ::= {
    "id": "41771983429993937",
    "name": "LUL",
    "animated": true
  }
  emoji = model.Emoji.from_json EMOJI_CUSTOM
  expect_equals "41771983429993937" emoji.id
  expect_equals "LUL" emoji.name
  expect emoji.is_animated

  EMOJI_CUSTOM2 ::= {
    "id": "41771983429993937",
    "name": null
  }
  emoji = model.Emoji.from_json EMOJI_CUSTOM2
  expect_equals "41771983429993937" emoji.id
  expect_null emoji.name

test_application:
  APPLICATION ::= {
    "bot_public": true,
    "bot_require_code_grant": false,
    "cover_image": "31deabb7e45b6c8ecfef77d2f99c81a5",
    "description": "Test",
    "guild_id": "290926798626357260",
    "icon": null,
    "id": "172150183260323840",
    "name": "Baba O-Riley",
    "owner": {
      "avatar": null,
      "discriminator": "1738",
      "flags": 1024,
      "id": "172150183260323840",
      "username": "i own a bot"
    },
    "primary_sku_id": "172150183260323840",
    "slug": "test",
    "summary": "",
    "team": {
      "icon": "dd9b7dcfdf5351b9c3de0fe167bacbe1",
      "id": "531992624043786253",
      "members": [
        {
          "membership_state": 2,
          "permissions": ["*"],
          "team_id": "531992624043786253",
          "user": {
            "avatar": "d9e261cd35999608eb7e3de1fae3688b",
            "discriminator": "0001",
            "id": "511972282709709995",
            "username": "Mr Owner"
          }
        }
      ]
    },
    "verify_key": "1e0a356058d627ca38a5c8c9648818061d49e49bd9da9e3ab17d98ad4d6bg2u8"
  }
  application := model.Application.from_json APPLICATION
  expect application.bot_is_public
  expect_not application.bot_requires_code_grant
  expect_equals "31deabb7e45b6c8ecfef77d2f99c81a5" application.cover_image
  expect_equals "Test" application.description
  expect_equals "290926798626357260" application.guild_id
  expect_null application.icon
  expect_equals "172150183260323840" application.id
  expect_equals "Baba O-Riley" application.name
  owner/model.User := application.owner
  expect_null owner.avatar
  expect_equals "1738" owner.discriminator
  expect_equals 1024 owner.flags_value
  flags := owner.flags
  // TODO(florian): test flags.
  expect_equals "172150183260323840" owner.id
  expect_equals "i own a bot" owner.username
  expect_equals "172150183260323840" application.primary_sku_id
  expect_equals "test" application.slug
  // Note that "summary" is deprecated and not supported by this library.
  team/model.Team := application.team
  expect_equals "dd9b7dcfdf5351b9c3de0fe167bacbe1" team.icon
  expect_equals "531992624043786253" team.id
  expect_equals 1 team.members.size
  member/model.TeamMember := team.members[0]
  expect_equals model.TeamMember.MEMBERSHIP_ACCEPTED member.membership_state
  expect_equals ["*"] member.permissions
  expect_equals "531992624043786253" member.team_id
  member_user/model.User := member.user
  expect_equals "d9e261cd35999608eb7e3de1fae3688b" member_user.avatar
  expect_equals "0001" member_user.discriminator
  expect_equals "511972282709709995" member_user.id
  expect_equals "Mr Owner" member_user.username
  expect_equals
      "1e0a356058d627ca38a5c8c9648818061d49e49bd9da9e3ab17d98ad4d6bg2u8"
      application.verify_key

test_components:
  COMPONENTS1 ::= [
    {
      "type": 1,
      "components": []
    }
  ]
  components := COMPONENTS1.map: model.Component.from_json it
  expect_equals 1 components.size
  component/model.Component := components[0]
  expect component is model.ComponentActionRow
  action_row_component := component as model.ComponentActionRow
  expect_equals 0 action_row_component.components.size

  COMPONENTS2 ::= [
    {
      "type": 1,
      "components": [
        {
          "type": 2,
          "label": "Click me!",
          "style": 1,
          "custom_id": "click_one"
        }
      ]
    }
  ]
  components = COMPONENTS2.map: model.Component.from_json it
  expect_equals 1 components.size
  component = components[0]
  expect component is model.ComponentActionRow
  action_row_component = component as model.ComponentActionRow
  expect_equals 1 action_row_component.components.size
  component = action_row_component.components[0]
  expect component is model.ComponentButton
  button := component as model.ComponentButton
  expect_equals "Click me!" button.label
  expect_equals model.ComponentButton.STYLE_PRIMARY button.style
  expect_equals "click_one" button.custom_id

  COMPONENTS3 ::= [
    {
      "type": 1,
      "components": [
        {
          "type": 3,
          "custom_id": "class_select_1",
          "options":[
            {
              "label": "Rogue",
              "value": "rogue",
              "description": "Sneak n stab",
              "emoji": {
                "name": "rogue",
                "id": "625891304148303894"
              }
            },
            {
              "label": "Mage",
              "value": "mage",
              "description": "Turn 'em into a sheep",
              "emoji": {
                "name": "mage",
                "id": "625891304081063986"
              }
            },
            {
              "label": "Priest",
              "value": "priest",
              "description": "You get heals when I'm done doing damage",
              "emoji": {
                "name": "priest",
                "id": "625891303795982337"
              }
            }
          ],
          "placeholder": "Choose a class",
          "min_values": 1,
          "max_values": 3
        }
      ]
    }
  ]
  components = COMPONENTS3.map: model.Component.from_json it
  expect_equals 1 components.size
  component = components[0]
  expect component is model.ComponentActionRow
  action_row_component = component as model.ComponentActionRow
  expect_equals 1 action_row_component.components.size
  component = action_row_component.components[0]
  expect component is model.ComponentSelect
  expect_equals model.Component.TYPE_STRING_SELECT component.type
  select := component as model.ComponentSelect
  expect_equals "class_select_1" select.custom_id
  options := select.options
  expect_equals 3 options.size
  option/model.SelectOption := options[0]
  expect_equals "Rogue" option.label
  expect_equals "rogue" option.value
  expect_equals "Sneak n stab" option.description
  emoji := option.emoji
  expect_equals "rogue" emoji.name
  expect_equals "625891304148303894" emoji.id
  option = options[1]
  expect_equals "Mage" option.label
  expect_equals "mage" option.value
  expect_equals "Turn 'em into a sheep" option.description
  emoji = option.emoji
  expect_equals "mage" emoji.name
  expect_equals "625891304081063986" emoji.id
  option = options[2]
  expect_equals "Priest" option.label
  expect_equals "priest" option.value
  expect_equals "You get heals when I'm done doing damage" option.description
  emoji = option.emoji
  expect_equals "priest" emoji.name
  expect_equals "625891303795982337" emoji.id
  expect_equals "Choose a class" select.placeholder
  expect_equals 1 select.min_values
  expect_equals 3 select.max_values

  COMPONENTS4 ::= [
    {
      "type": 1,
      "components": [{
        "type": 4,
        "custom_id": "name",
        "label": "Name",
        "style": 1,
        "min_length": 1,
        "max_length": 4000,
        "placeholder": "John",
        "required": true
      }]
    }
  ]
  components = COMPONENTS4.map: model.Component.from_json it
  expect_equals 1 components.size
  component = components[0]
  expect component is model.ComponentActionRow
  action_row_component = component as model.ComponentActionRow
  expect_equals 1 action_row_component.components.size
  component = action_row_component.components[0]
  expect component is model.ComponentTextInput
  text_input := component as model.ComponentTextInput
  expect_equals "name" text_input.custom_id
  expect_equals "Name" text_input.label
  expect_equals model.ComponentTextInput.STYLE_SHORT text_input.style
  expect_equals 1 text_input.min_length
  expect_equals 4000 text_input.max_length
  expect_equals "John" text_input.placeholder
  expect text_input.is_required
