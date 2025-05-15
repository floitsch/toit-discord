// Copyright (C) 2023 Florian Loitsch.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the TESTS_LICENSE file.

import discord.model
import expect show *

main:
  test-user
  test-guild
  test-guild-member
  test-channel
  test-welcome-screen
  test-message
  test-emoji
  test-application
  test-components

test-user:
  EXAMPLE-USER := {
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
  user := model.User.from-json EXAMPLE-USER
  expect-equals "80351110224678912" user.id
  expect-equals "Nelly" user.username
  expect-equals "1337" user.discriminator
  expect-equals "8342729096ea3675442027381ff50dfe" user.avatar
  expect user.is-verified
  expect-equals "nelly@discord.com" user.email
  expect-equals 64 user.flags-value
  expect-equals "06c16474723fe537c283b8efa61a30c8" user.banner
  expect-equals 16711680 user.accent-color
  expect-equals 1 user.premium-type
  expect-equals 64 user.public-flags-value

test-guild:
  EXAMPLE-GUILD ::= {
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

  guild := model.Guild.from-json EXAMPLE-GUILD
  expect guild.is-available
  expect-equals "197038439483310086" guild.id
  expect-equals "Discord Testers" guild.name
  expect-equals "f64c482b807da4f539cff778d174971c" guild.icon
  expect-equals "The official place to report Discord Bugs!" guild.description
  expect-null guild.splash
  expect-null guild.discovery-splash
  expect-equals ["ANIMATED_ICON", "VERIFIED", "NEWS", "VANITY_URL", "DISCOVERABLE", "MORE_EMOJI", "INVITE_SPLASH", "BANNER", "COMMUNITY"] guild.features
  expect-equals [] guild.emojis
  expect-equals "9b6439a7de04f1d26af92f84ac9e1e4a" guild.banner
  expect-equals "73193882359173120" guild.owner-id
  expect-null guild.application-id
  expect-null guild.region
  expect-null guild.afk-channel-id
  expect-equals 300 guild.afk-timeout
  expect-null guild.system-channel-id
  expect guild.is-widget-enabled
  expect-null guild.widget-channel-id
  expect-equals 3 guild.verification-level
  expect-equals [] guild.roles
  expect-equals 1 guild.default-message-notifications
  expect-equals 1 guild.mfa-level
  expect-equals 2 guild.explicit-content-filter
  expect-equals 40000 guild.max-presences
  expect-equals 250000 guild.max-members
  expect-equals "discord-testers" guild.vanity-url-code
  expect-equals 3 guild.premium-tier
  expect-equals 33 guild.premium-subscription-count
  expect-equals 0 guild.system-channel-flags-value
  expect-equals "en-US" guild.preferred-locale
  expect-equals "441688182833020939" guild.rules-channel-id
  expect-equals "281283303326089216" guild.public-updates-channel-id

  UNAVAILABLE-GUILD ::= {
    "id": "41771983423143937",
    "unavailable": true
  }
  guild = model.Guild.from-json UNAVAILABLE-GUILD
  expect-not guild.is-available
  expect-equals "41771983423143937" guild.id

test-guild-member:
  GUILD-MEMBER ::= {
    "user": {:},
    "nick": "NOT API SUPPORT",
    "avatar": null,
    "roles": [],
    "joined_at": "2015-04-26T06:26:56.936000+00:00",
    "deaf": false,
    "mute": false
  }
  guild-member := model.GuildMember.from-json GUILD-MEMBER
  expect-equals "NOT API SUPPORT" guild-member.nick
  expect-null guild-member.avatar
  expect-equals [] guild-member.roles
  expect-equals "2015-04-26T06:26:56.936000+00:00" guild-member.joined-at-value
  time := guild-member.joined-at
  expect-equals 2015 time.utc.year
  expect-equals 4 time.utc.month
  expect-equals 26 time.utc.day
  expect-equals 6 time.utc.h
  expect-equals 26 time.utc.m
  expect-equals 56 time.utc.s
  expect-equals 936_000_000 time.utc.ns
  expect-not guild-member.is-deaf
  expect-not guild-member.is-mute

test-channel:
  TEXT-CHANNEL ::= {
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
  channel := model.Channel.from-json TEXT-CHANNEL
  expect-equals "41771983423143937" channel.id
  expect-equals "41771983423143937" channel.guild-id
  expect-equals "general" channel.name
  expect-equals model.Channel.TYPE-GUILD-TEXT channel.type
  expect-equals 6 channel.position
  expect-equals [] channel.permission-overwrites
  expect-equals 2 channel.rate-limit-per-user
  expect channel.is-nsfw
  expect-equals "24/7 chat about how to gank Mike #2" channel.topic
  expect-equals "155117677105512449" channel.last-message-id
  expect-equals "399942396007890945" channel.parent-id
  expect-equals 60 channel.default-auto-archive-duration

  ANNOUNCEMENT-CHANNEL ::= {
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
  channel = model.Channel.from-json ANNOUNCEMENT-CHANNEL
  expect-equals "41771983423143937" channel.id
  expect-equals "41771983423143937" channel.guild-id
  expect-equals "important-news" channel.name
  expect-equals model.Channel.TYPE-GUILD-ANNOUNCEMENT channel.type
  expect-equals 6 channel.position
  expect-equals [] channel.permission-overwrites
  expect channel.is-nsfw
  expect-equals "Rumors about Half Life 3" channel.topic
  expect-equals "155117677105512449" channel.last-message-id
  expect-equals "399942396007890945" channel.parent-id
  expect-equals 60 channel.default-auto-archive-duration

  VOICE-CHANNEL ::= {
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
  channel = model.Channel.from-json VOICE-CHANNEL
  expect-equals "155101607195836416" channel.id
  expect-equals "174629835082649376" channel.last-message-id
  expect-equals model.Channel.TYPE-GUILD-VOICE channel.type
  expect-equals "ROCKET CHEESE" channel.name
  expect-equals 5 channel.position
  expect-null channel.parent-id
  expect-equals 64000 channel.bitrate
  expect-equals 0 channel.user-limit
  expect-null channel.rtc-region
  expect-equals "41771983423143937" channel.guild-id
  expect-equals [] channel.permission-overwrites
  expect-equals 0 channel.rate-limit-per-user
  expect-not channel.is-nsfw

  DM-CHANNEL ::= {
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
  channel = model.Channel.from-json DM-CHANNEL
  expect-equals "3343820033257021450" channel.last-message-id
  expect-equals model.Channel.TYPE-DM channel.type
  expect-equals "319674150115610528" channel.id
  expect-equals 1 channel.recipients.size
  user/model.User := channel.recipients[0]
  expect-equals "test" user.username
  expect-equals "9999" user.discriminator
  expect-equals "82198898841029460" user.id
  expect-equals "33ecab261d4681afa4d85a04691c4a01" user.avatar

test-welcome-screen:
  WELCOME-SCREEN ::= {
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

  welcome-screen := model.WelcomeScreen.from-json WELCOME-SCREEN
  expect-equals "Discord Developers is a place to learn about Discord's API, bots, and SDKs and integrations. This is NOT a general Discord support server." welcome-screen.description
  expect-equals 5 welcome-screen.welcome-channels.size
  expect-equals "697138785317814292" welcome-screen.welcome-channels[0].channel-id
  expect-equals "Follow for official Discord API updates" welcome-screen.welcome-channels[0].description
  expect-null welcome-screen.welcome-channels[0].emoji-id
  expect-equals "📡" welcome-screen.welcome-channels[0].emoji-name
  expect-equals "697236247739105340" welcome-screen.welcome-channels[1].channel-id
  expect-equals "Get help with Bot Verifications" welcome-screen.welcome-channels[1].description
  expect-null welcome-screen.welcome-channels[1].emoji-id
  expect-equals "📸" welcome-screen.welcome-channels[1].emoji-name
  expect-equals "697489244649816084" welcome-screen.welcome-channels[2].channel-id
  expect-equals "Create amazing things with Discord's API" welcome-screen.welcome-channels[2].description
  expect-null welcome-screen.welcome-channels[2].emoji-id
  expect-equals "🔬" welcome-screen.welcome-channels[2].emoji-name
  expect-equals "613425918748131338" welcome-screen.welcome-channels[3].channel-id
  expect-equals "Integrate Discord into your game" welcome-screen.welcome-channels[3].description
  expect-null welcome-screen.welcome-channels[3].emoji-id
  expect-equals "🎮" welcome-screen.welcome-channels[3].emoji-name
  expect-equals "646517734150242346" welcome-screen.welcome-channels[4].channel-id
  expect-equals "Find more places to help you on your quest" welcome-screen.welcome-channels[4].description
  expect-null welcome-screen.welcome-channels[4].emoji-id
  expect-equals "🔦" welcome-screen.welcome-channels[4].emoji-name

test-message:
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
  message := model.Message.from-json MESSAGE1
  expect-equals "Supa Hot" message.content
  expect-equals "334385199974967042" message.id
  expect-equals "290926798999357250" message.channel-id
  expect-equals model.Message.TYPE-DEFAULT message.type
  expect-equals "2017-07-11T17:27:07.299000+00:00" message.timestamp-value
  timestamp := message.timestamp
  expect-equals 2017 timestamp.utc.year
  expect-equals 7 timestamp.utc.month
  expect-equals 11 timestamp.utc.day
  expect-equals 17 timestamp.utc.h
  expect-equals 27 timestamp.utc.m
  expect-equals 7 timestamp.utc.s
  expect-equals 299_000_000 timestamp.utc.ns
  expect-not message.mentions-everyone
  expect-not message.is-pinned
  expect-not message.is-tts
  author := message.author
  expect author is model.User
  user := author as model.User
  expect-equals "Mason" user.username
  expect-equals "9999" user.discriminator
  expect-equals "53908099506183680" user.id
  expect-equals "a_bab14f271d565501444b2ca3be944b25" user.avatar
  expect-equals 1 message.reactions.size
  reaction/model.Reaction := message.reactions[0]
  expect-equals 1 reaction.count
  expect-not reaction.me
  emoji := reaction.emoji
  expect-equals "🔥" emoji.name
  expect-null emoji.id

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

  message = model.Message.from-json MESSAGE2
  expect-equals "Big news! In this <#278325129692446722> channel!" message.content
  expect-equals "334385199974967042" message.id
  expect-equals "290926798999357250" message.channel-id
  expect-equals model.Message.TYPE-DEFAULT message.type
  expect-equals "2017-07-11T17:27:07.299000+00:00" message.timestamp-value
  timestamp = message.timestamp
  expect-equals 2017 timestamp.utc.year
  expect-equals 7 timestamp.utc.month
  expect-equals 11 timestamp.utc.day
  expect-equals 17 timestamp.utc.h
  expect-equals 27 timestamp.utc.m
  expect-equals 7 timestamp.utc.s
  expect-equals 299_000_000 timestamp.utc.ns
  expect-not message.mentions-everyone
  expect-not message.is-pinned
  expect-not message.is-tts
  author = message.author
  expect author is model.User
  user = author as model.User
  expect-equals "Mason" user.username
  expect-equals "9999" user.discriminator
  expect-equals "53908099506183680" user.id
  expect-equals "a_bab14f271d565501444b2ca3be944b25" user.avatar
  expect-equals 1 message.reactions.size
  reaction = message.reactions[0]
  expect-equals 1 reaction.count
  expect-not reaction.me
  emoji = reaction.emoji
  expect-equals "🔥" emoji.name
  expect-null emoji.id
  expect-equals 1 message.mention-channels.size
  channel/model.ChannelMention := message.mention-channels[0]
  expect-equals "278325129692446722" channel.id
  expect-equals "278325129692446720" channel.guild-id
  expect-equals "big-news" channel.name
  expect-equals model.Channel.TYPE-GUILD-ANNOUNCEMENT channel.type

test-emoji:
  EMOJI-PREMIUM ::= {
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
  emoji := model.Emoji.from-json EMOJI-PREMIUM
  expect-equals "41771983429993937" emoji.id
  expect-equals "LUL" emoji.name
  expect-equals 2 emoji.roles.size
  expect-equals "41771983429993000" emoji.roles[0]
  expect-equals "41771983429993111" emoji.roles[1]
  expect-equals 131328 emoji.user.public-flags-value
  flags := emoji.user.public-flags
  // TODO(florian): test flags.
  expect emoji.requires-colons
  expect-not emoji.is-managed
  expect-not emoji.is-animated

  EMOJI-STANDARD ::= {
    "id": null,
    "name": "🔥",
  }
  emoji = model.Emoji.from-json EMOJI-STANDARD
  expect-null emoji.id
  expect-equals "🔥" emoji.name

  EMOJI-CUSTOM ::= {
    "id": "41771983429993937",
    "name": "LUL",
    "animated": true
  }
  emoji = model.Emoji.from-json EMOJI-CUSTOM
  expect-equals "41771983429993937" emoji.id
  expect-equals "LUL" emoji.name
  expect emoji.is-animated

  EMOJI-CUSTOM2 ::= {
    "id": "41771983429993937",
    "name": null
  }
  emoji = model.Emoji.from-json EMOJI-CUSTOM2
  expect-equals "41771983429993937" emoji.id
  expect-null emoji.name

test-application:
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
  application := model.Application.from-json APPLICATION
  expect application.bot-is-public
  expect-not application.bot-requires-code-grant
  expect-equals "31deabb7e45b6c8ecfef77d2f99c81a5" application.cover-image
  expect-equals "Test" application.description
  expect-equals "290926798626357260" application.guild-id
  expect-null application.icon
  expect-equals "172150183260323840" application.id
  expect-equals "Baba O-Riley" application.name
  owner/model.User := application.owner
  expect-null owner.avatar
  expect-equals "1738" owner.discriminator
  expect-equals 1024 owner.flags-value
  flags := owner.flags
  // TODO(florian): test flags.
  expect-equals "172150183260323840" owner.id
  expect-equals "i own a bot" owner.username
  expect-equals "172150183260323840" application.primary-sku-id
  expect-equals "test" application.slug
  // Note that "summary" is deprecated and not supported by this library.
  team/model.Team := application.team
  expect-equals "dd9b7dcfdf5351b9c3de0fe167bacbe1" team.icon
  expect-equals "531992624043786253" team.id
  expect-equals 1 team.members.size
  member/model.TeamMember := team.members[0]
  expect-equals model.TeamMember.MEMBERSHIP-ACCEPTED member.membership-state
  expect-equals ["*"] member.permissions
  expect-equals "531992624043786253" member.team-id
  member-user/model.User := member.user
  expect-equals "d9e261cd35999608eb7e3de1fae3688b" member-user.avatar
  expect-equals "0001" member-user.discriminator
  expect-equals "511972282709709995" member-user.id
  expect-equals "Mr Owner" member-user.username
  expect-equals
      "1e0a356058d627ca38a5c8c9648818061d49e49bd9da9e3ab17d98ad4d6bg2u8"
      application.verify-key

test-components:
  COMPONENTS1 ::= [
    {
      "type": 1,
      "components": []
    }
  ]
  components := COMPONENTS1.map: model.Component.from-json it
  expect-equals 1 components.size
  component/model.Component := components[0]
  expect component is model.ComponentActionRow
  action-row-component := component as model.ComponentActionRow
  expect-equals 0 action-row-component.components.size

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
  components = COMPONENTS2.map: model.Component.from-json it
  expect-equals 1 components.size
  component = components[0]
  expect component is model.ComponentActionRow
  action-row-component = component as model.ComponentActionRow
  expect-equals 1 action-row-component.components.size
  component = action-row-component.components[0]
  expect component is model.ComponentButton
  button := component as model.ComponentButton
  expect-equals "Click me!" button.label
  expect-equals model.ComponentButton.STYLE-PRIMARY button.style
  expect-equals "click_one" button.custom-id

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
  components = COMPONENTS3.map: model.Component.from-json it
  expect-equals 1 components.size
  component = components[0]
  expect component is model.ComponentActionRow
  action-row-component = component as model.ComponentActionRow
  expect-equals 1 action-row-component.components.size
  component = action-row-component.components[0]
  expect component is model.ComponentSelect
  expect-equals model.Component.TYPE-STRING-SELECT component.type
  select := component as model.ComponentSelect
  expect-equals "class_select_1" select.custom-id
  options := select.options
  expect-equals 3 options.size
  option/model.SelectOption := options[0]
  expect-equals "Rogue" option.label
  expect-equals "rogue" option.value
  expect-equals "Sneak n stab" option.description
  emoji := option.emoji
  expect-equals "rogue" emoji.name
  expect-equals "625891304148303894" emoji.id
  option = options[1]
  expect-equals "Mage" option.label
  expect-equals "mage" option.value
  expect-equals "Turn 'em into a sheep" option.description
  emoji = option.emoji
  expect-equals "mage" emoji.name
  expect-equals "625891304081063986" emoji.id
  option = options[2]
  expect-equals "Priest" option.label
  expect-equals "priest" option.value
  expect-equals "You get heals when I'm done doing damage" option.description
  emoji = option.emoji
  expect-equals "priest" emoji.name
  expect-equals "625891303795982337" emoji.id
  expect-equals "Choose a class" select.placeholder
  expect-equals 1 select.min-values
  expect-equals 3 select.max-values

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
  components = COMPONENTS4.map: model.Component.from-json it
  expect-equals 1 components.size
  component = components[0]
  expect component is model.ComponentActionRow
  action-row-component = component as model.ComponentActionRow
  expect-equals 1 action-row-component.components.size
  component = action-row-component.components[0]
  expect component is model.ComponentTextInput
  text-input := component as model.ComponentTextInput
  expect-equals "name" text-input.custom-id
  expect-equals "Name" text-input.label
  expect-equals model.ComponentTextInput.STYLE-SHORT text-input.style
  expect-equals 1 text-input.min-length
  expect-equals 4000 text-input.max-length
  expect-equals "John" text-input.placeholder
  expect text-input.is-required
