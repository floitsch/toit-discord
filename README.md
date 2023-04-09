# Discord

A minimal Discord client in Toit.

This library is a work in progress. If you are missing a feature, please open an issue.

Patches are welcome.

## Token
You need to create a bot account and get a token.

- Go to https://discord.com/developers.
- Create a new application.
- Go to the "Bot" tab.
- Click "Add Bot".
- Click "Yes, do it!".
- Reset the token and copy it. Pass it as argument to the Discord client.
- If you want to read messages, also enable the privileged gateway intents
  on the same page. Specifically, enable the "Message Content Intent".

## Adding a bot to a server
Go to the "OAuth2" tab.

For authorization, there are two options:
- create a custom URL, or
- set the default authorization link. (Only works for public bots.)

The custom URL is faster for testing, but the default authorization link is
  more convenient for users.

In both cases, go to the "OAuth2" section.

For the custom URL, go to the URL Generator. Click on "bot" (but no other) and
then select the permissions you want. Give this URL to users who want to add the
bot. Note: if the bot is private, you are the only one who can add it to
guilds.

For the default authorization link, go to the "General" tab, and change the
Authorization Method to "In-app Authorization" in the "Default Authorization Link"
section. Choose "bot" and the permissions the bot should have.

## Features and bugs
Please file feature requests and bugs at the [issue tracker](https://github.com/floitsch/toit-discord/issues).
