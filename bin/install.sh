#!/bin/sh

echo -n "Install Nix (y/N)? "
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo -n "Installing Nix..."
    curl -L https://nixos.org/nix/install | sh
    wait 1
    NIX_PROFILES=/nix/var/nix/profiles/default "${HOME}"/.nix-profile
    NIX_PATH="${HOME}"/.nix-defexpr/channels
    PATH="${PATH}:${HOME}/.nix-profile/bin"
    "${HOME}/.nix-profile/bin/nix-channel" --add https://nixos.org/channels/nixpkgs-unstable
    "${HOME}/.nix-profile/bin/nix-channel" --update
    "${HOME}/.nix-profile/bin/nix-env" -iA nixpkgs.nixUnstable
    mkdir -p ~/.config/nix
    echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
    echo "source ${HOME}/.nix-profile/etc/profile.d/nix.sh" >> ~/.bashrc
    echo "Please reload your environment"
    exit 0
else
    echo -n "Skipping Nix install"
fi

echo "Creating activation package at ${HOME}"
cd "${HOME}"

 "${HOME}/.nix-profile/bin/nix" build https://github.com/viperML/dotfiles/archive/master.tar.gz#homeManagerConfigurations.ayats.activationPackage
./result/activate
