#!/bin/bash
# Script to run after installing a fresh copy of Ubuntu. These are just some basic personalizations and quality-of-life things that I like.
# TODO:
# - Download some sick wallpapaer backgrounds into ~/Pictures/'Desktop Backgrounds'

# Update package repository cache
sudo add-apt-repository multiverse
sudo add-apt-repository ppa:mozillacorp/mozillavpn
sudo apt-get update
sudo apt-get upgrade

# Install nice programs
# xclip
sudo apt-get install xclip

# Notepadqq
sudo apt-get install notepadqq

# Vim
sudo apt-get install --assume-yes vim

# HTop
sudo apt-get install htop

# Codecs-n-such
sudo apt-get install ubuntu-restricted-extras

# VLC
sudo apt-get install vlc

# Mozilla Firefox
sudo apt-get install firefox

# Mozilla VPN
sudo apt-get install resolvconf mozillavpn
echo "[Desktop Entry]
Name=MozillaVPN
Version=1.0
Exec=/usr/bin/mozillavpn ui -m -s
Comment=A fast, secure and easy to use VPN. Built by the makers of Firefox.
Type=Application
Icon=mozillavpn
OnlyShowIn=GNOME;Unity;MATE;
X-GNOME-AutoRestart=false
X-GNOME-Autostart-Notify=true" >/etc/xdg/autostart/MozillaVPN-startup.desktop
# Trask-cli
sudo apt-get install trash-cli

# Wallch
sudo apt-get install libcanberra-gtk-module libcanberra-gtk3-module
sudo apt-get install wallch
mkdir -p ~/Pictures/'Desktop Backgrounds'
echo "[Desktop Entry]
Type=Application
Name=Wallch
Exec=bash -c 'sleep 3 && /usr/bin/wallch --none'
Terminal=false
Icon=wallch
Comment=Just show indicator
Categories=Utility;Application;" >~/.config/autostart/wallch.desktop

# Gammy
cd ~/
sudo apt-get install git build-essential libgl1-mesa-dev qt5-default
git clone https://github.com/Fushko/gammy.git
cd gammy
qmake Gammy.pro
make sudo make install
cd ~/
echo "[Desktop Entry]
Type=Application
Exec=/opt/gammy/bin/gammy
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Gammy adaptive screen brightness" >~/.config/autostart/gammy.desktop

# Config

# Remove trash and home directory links from desktop
gsettings set org.gnome.shell.extensions.desktop-icons show-home false
gsettings set org.gnome.shell.extensions.desktop-icons show-trash false

# Set dock to auto-hide on the bottom of the screen
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide-mode 'ALL_WINDOWS'

# Dock icon size
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 38

# Windows color Dark Theme
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'

# Add right-click option for new document
mkdir -p ~/Templates/Text/
touch ~/Templates/Text/Document

# Keyboard Shortcuts
# Install superMin script
sudo apt-get install xdotool wmctrl x11-utils
source "$(dirname -- "$(readlink -f "${BASH_SOURCE}")")"/uniloc.sh
mkdir -p ~/.custom_keyboard_shortcut_scripts
cp ${SCRIPT_DIR}/superMin.sh ~/.custom_keyboard_shortcut_scripts

BEGINNING="gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

KEY_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
"['$KEY_PATH/custom0/', '$KEY_PATH/custom1/']"

# Add Super+E to launch file browser
$BEGINNING/custom0/ name 'Launch File Explorer'
$BEGINNING/custom0/ binding '<Super>e'
$BEGINNING/custom0/ command 'nautilus --browser'

# Set Super+Down to minimize a window
# Free up Super+Down keyboard shortcu which is taken by restore by default
gsettings set org.gnome.desktop.wm.keybindings unmaximize ['']

# Wire up Super+Down
$BEGINNING/custom1/ name 'Super Minimize'
$BEGINNING/custom1/ binding '<Super>Down'
$BEGINNING/custom1/ command '/home/'$USER'/.custom_keyboard_shortcut_scripts/superMin.sh'

# Periodically Flush the Trash
(crontab -l 2>/dev/null; echo "0 12 * * 7 trash-empty 14")|awk '!x[$0]++'|crontab -

# Periodically Update and Clean
(sudo crontab -l 2>/dev/null; echo "0 12 12 * * apt-git update")|awk '!x[$0]++'| sudo crontab -
(sudo crontab -l 2>/dev/null; echo "0 12 13 * * apt-git upgrade")|awk '!x[$0]++'| sudo crontab -
(sudo crontab -l 2>/dev/null; echo "0 12 14 * * apt-git autoremove")|awk '!x[$0]++'| sudo crontab -
