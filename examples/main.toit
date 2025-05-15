// Copyright (C) 2023 Florian Loitsch.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

import discord show *
import host.os
import monitor

main:
  token := os.env.get "DISCORD_TOKEN"
  if not token or token == "":
    print "Please set the DISCORD_TOKEN environment variable."
    return

  url := os.env.get "DISCORD_URL"

  main --token=token --url=url

/**
When developing for the ESP32 a good practice is to have
  a different file (say 'esp32.toit') that just calls this main.
Check in an 'esp32-example.toit' file, but don't check in the 'esp32.toit'
  file that contains the actual credentials. It should be '.gitignore'd.

```
import .main as real_main

TOKEN ::= "YOUR TOKEN"
URL ::= "YOUR URL"

main:
  real_main.main --token=TOKEN --url=URL
```
*/
main --token/string --url/string?:
  if url and url != "":
    print "To invite the bot to a channel go to $url"

  client := Client --token=token

  my-id/string? := null

  start-delayed := ::
    guilds := client.guilds
    print "I am in $guilds.size guilds"

    guilds.do: | guild/Guild |
      channels := client.channels guild.id
      print "- $guild.name has $channels.size channels."

      filtered := channels.filter: | channel/Channel | channel.name == "general"
      if not filtered.is-empty:
        general-channel-id := filtered[0].id
        print "The general channel id is $general-channel-id"

        messages := client.messages general-channel-id --limit=5
        print "The last 5 messages are:"
        messages.do: print "  $it"

  intents := 0
    | INTENT-GUILDS
    | INTENT-GUILD-MEMBERS
    | INTENT-GUILD-MESSAGES
    | INTENT-GUILD-MESSAGE-REACTIONS
    | INTENT-GUILD-MESSAGE-TYPING
    | INTENT-DIRECT-MESSAGES
    | INTENT-DIRECT-MESSAGE-REACTIONS
    | INTENT-DIRECT-MESSAGE-TYPING
    // Make sure to enable privileged gateway intents for your bot.
    | INTENT-GUILD-MESSAGE-CONTENT

  // Avoid taking too much time when handling events.
  client.listen --intents=intents: | event/Event? |
    if event is EventReady:
      // The Reade event is relatively big.
      // It's a good idea to wait with other connections (or anything that could
      //   use memory) until that event has been processed.
      ready/EventReady? := event as EventReady
      my-id = ready.user.id
      // Let the GC delete the event and the ready object.
      event = null
      ready = null
      start-delayed.call

    if event is EventMessageCreate:
      message := (event as EventMessageCreate).message
      if message.author.id == my-id: continue.listen

      print "Message: $message.content"
      if (message.mentions.any: it.id == my-id):
        print "I was mentioned in $message"
        client.send-message "Hello from Toit" --channel-id=message.channel-id

    if event is EventMessageReactionAdd:
      reaction := event as EventMessageReactionAdd
      print "Reaction: $reaction.emoji"
