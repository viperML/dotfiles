#!/bin/sh

echo -n "Install Nix (y/N)? "
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo -n "Installing Nix..."
    curl -L https://nixos.org/nix/install | sh
    nix-channel --add https://nixos.org/channels/nixpkgs-unstable
    nix-channel --update
    nix-env -iA nixpkgs.nixUnstable
    mkdir -p ~/.config/nix
    echo "experimental-features = nix-command flakes" > tee ~/.config/nix/nix.conf
else
    echo -n "Skipping Nix install"
fi

