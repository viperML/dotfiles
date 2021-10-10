#!/bin/sh

echo -n "Install Nix (y/N)? "
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo -n "Installing Nix..."
    curl -L https://nixos.org/nix/install | sh
    wait 1
    echo "source ${HOME}/.nix-profile/etc/profile.d/nix.sh" >> ~/.bashrc
    echo "Please close this shell"
    exit 0
else
    echo "Skipping Nix install"
fi

echo "Adjusting the user name..."
sed -i "s/username = .*/username = \"$(whoami)\";/g" flake.nix

echo "Pulling the latest version..."
git fetch
git merge

echo "Creating activation package"
nix build .#mkHM.default.activationPackage

echo "Activating..."
exec ./result/activate
