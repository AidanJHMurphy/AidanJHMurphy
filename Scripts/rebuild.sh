#!/bin/bash
echo "fix your dotfile management first"
# taken shamelessly from https://www.youtube.com/watch?v=CwfKlX3rA6E&list=PLzz6INwlcvnJpKI2_Fsp-i7U7aT7pN4lc&index=37&t=20s
set -e
# should probably use better dotfile management
# and not edit directly in /etc/nixos/
# but rather do a soft link thing
# Consider gnu stow: https://www.youtube.com/watch?v=y6XCebnB9gs
pushd /etc/nixos/
nvim configuration.nix
# look into https://github.com/kamadorueda/alejandra
# alejandra . &>dev/null
git diff -U0 *.nix
echo "NixOS Rebuilding ..."
sudo nixos-rebuild switch &>nixos-switch.log || (cat nixos-switch.log | grep --color error && false)
gen=$(nixos-rebuild list-gnerations | grep current)
pit commit -am "$gen"
popd
