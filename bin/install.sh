#!/bin/sh

echo -n "Install Nix (y/N)? "
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo -n "Installing Nix..."
    curl -L https://nixos.org/nix/install | sh
    wait 1
    echo "source ${HOME}/.nix-profile/etc/profile.d/nix.sh" >> ~/.bashrc
    exit 0
else
    echo "Skipping Nix install"
fi

echo "Changing the username in flake.nix"
sed -i "s/ username = .*/ username = \"$(whoami)\";/g" flake.nix
echo "Changing the hostname in flake.nix"
sed -i "s/ hostname = .*/ username = \"$(cat /etc/hostname)\";/g" flake.nix

echo "Pulling the latest version..."
git fetch
git merge

echo "Creating activation package"
nix-shell --run "nix build"

echo "Activating..."
./result/activate
