#!/bin/bash
# Script to run after installing a fresh copy of Ubuntu. These are just some basic personalizations and quality-of-life things that I like.
# TODO:
# - Install:
#  - xclip
#  - notepad qq
#  - Mozilla VPN
#  - htop
#  - vim
#  - VLC Media Player
#  - All of the various codecs that don't come with a normal distro 
#  - Wallch
#   - Download some sick wallpapaer backgrounds
#   - Configurre wallch to rotate daily from those images
#  - trash-cli
#   - configure cron to flush garbage once a week
#  - Gammy
#   - Figure out what config can be done from a script
# - Config:
#  - Add right-click => New File option
#  - Add Super+E hotkey to open file explorer
#  - Select Dark Theme
#  - Move Navigation to bottom
#  - Set dock to Auto Hide
#  - Icon Size 38
#  - Start up apps
#   - Wallch
#   - Gammy
#   - Mozilla VPN

# Remove trash and home directory links from desktop
gsettings set org.gnome.shell.extensions.desktop-icons show-home false
gsettings set org.gnome.shell.extensions.desktop-icons show-trash false
