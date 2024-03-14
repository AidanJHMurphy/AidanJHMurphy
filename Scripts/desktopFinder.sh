#!/bin/sh

# These should match the application names from /etc/nixos/configuration.nix
applications=(nextcloud-client keepassxc protonvpn-gui)

for application in "${applications[@]}"; do
    path=$(nix-build --no-out-link '<nixpkgs>' -A $application)
    ln -s -f $(find $path -name "*.desktop" -type f) $HOME/.config/autostart/
done;
