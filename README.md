# AISasha

A telegram administration bot based on TeleSeed and part of DBTeam
It's both in English and Italian, you have just to write the command to install the strings

# Commands

All commands are available with command /help, learn to use it it's all explained

# Installation

```sh
# Install dependencies.
# Tested on Ubuntu 14.04. For other OSs, check out https://github.com/yagop/telegram-bot/wiki/Installation
sudo apt-get install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev lua-socket lua-sec lua-expat libevent-dev make unzip git redis-server autoconf g++ libjansson-dev libpython-dev expat libexpat1-dev

# Let's install the bot.
cd $HOME
git clone https://github.com/xsolinsx/AISasha.git
cd AISasha
chmod +x launch.sh
./launch.sh install
./launch.sh # Enter a phone number & confirmation code.
```
# One command
To install everything in one command (useful for VPS deployment) on Debian-based distros, use:
```sh
#https://github.com/yagop/telegram-bot/wiki/Installation
sudo apt-get update; sudo apt-get upgrade -y --force-yes; sudo apt-get dist-upgrade -y --force-yes; sudo apt-get install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev lua-socket lua-sec lua-expat libevent-dev libjansson* libpython-dev make unzip git redis-server g++ autoconf -y --force-yes && git clone https://github.com/xsolinsx/AISasha.git && cd AISasha && chmod +x launch.sh && ./launch.sh install && ./launch.sh
```

# Realm configuration

After you run the bot for first time, send it `!id`. Get your ID and stop the bot.

Open ./data/config.lua and add your ID to the "sudo_users" section in the following format:
```
  sudo_users = {
    123456789,
    987654321,
    YourID
  }
```
Then restart the bot.

Open ./bot/seedbot.lua and in check_tag function change my tag @EricSolinas with yours, then if someone tags you in a group where there is your bot you will be notified in pm.

Write in pm to your bot `/installenstrings` (or `/installitstrings` if you are Italian), with that command the bot will install the text to interact, otherwise will send an error saying that it can't find the string of text

Create a realm using the `!createrealm` command.

Creating a LOG SuperGroup
	-For GBan Log

	1. Create a group using the `!creategroup` command.
	2. Add two members or bots, then use `#Tosuper` to convert to a SuperSroup.
	3. Use the `#addlog` command and your ***LOG SuperGroup(s)*** will be set.
	Note: you can set multiple Log SuperGroups
