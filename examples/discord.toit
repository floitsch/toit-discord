
import discord show *
import host.os

DISCORD_TOKEN ::= ""
DISCORD_URL ::= ""

main:
  url := DISCORD_URL
  token := DISCORD_TOKEN
  if token == "":
    token = os.env.get "DISCORD_TOKEN"
  if token == "":
    print "Please set the DISCORD_TOKEN environment variable."
    return

  if url == "":
    url = os.env.get "DISCORD_URL"

  if url != "":
    print "To invite the bot to a channel go to $url"

  discord := Client --token=token
  discord.connect

  me := discord.me
  my_id := me["id"]
  print "My id is $my_id"

  guilds := discord.guilds
  print "I am in $guilds.size guilds"

  test_guild := (guilds.filter: it["name"] == "testing server")[0]
  test_guild_id := test_guild["id"]
  print "The testing server id is $test_guild_id"

  channels := discord.channels test_guild_id
  print "The testing server has $channels.size channels"

  general_channel := (channels.filter: it["name"] == "general")[0]
  general_channel_id := general_channel["id"]
  print "The general channel id is $general_channel_id"

  messages := discord.messages general_channel_id
  print "The general channel has $messages.size messages"
  messages[max 0 (messages.size - 20)..].do:
    print "  $it"

  inspected_channels := {}

  discord.listen_for_notifications:
    print "Got notification $it"
    if it["t"] == "MESSAGE_CREATE":
      message := it["d"]
      if message["author"]["id"] == my_id: continue.listen_for_notifications

      channel_id := message["channel_id"]
      if not inspected_channels.contains channel_id :
        channel := discord.channel channel_id
        print "Channel $channel_id is $channel"
        inspected_channels.add channel_id

      print "Message: $message["content"]"
      if (message["mentions"].any: it["id"] == my_id):
        print "I was mentioned in $message"
        discord.send_message "Hello from Toit" --channel_id=channel_id


/*
    me := request_ "/users/@me"
    my_id := me["id"]
    guild_id := (request_ "/users/@me/guilds")[0]["id"]
    request_ "/guilds/$guild_id"
    channels := request_ "/guilds/$guild_id/channels"
    channel_id := (channels.filter: it["type"] == 0)[0]["id"]
    messages := request_ "/channels/$channel_id/messages"
    send_message "Hello from Toit" --channel_id=channel_id
*/

