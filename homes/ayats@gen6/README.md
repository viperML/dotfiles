```bash
NIX_USER_CONF_FILES=$PWD/misc/nix.conf:$PWD/homes/ayats@gen6/nix.conf nix-build -A homeConfigurations."ayats@gen6".activationPackage $PWD

echo ". $HOME/.config/nix/rc" >> $HOME/.bashrc
```
