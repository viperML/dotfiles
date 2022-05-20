```bash
NIX_USER_CONF_FILES=$PWD/misc/nix.conf:$PWD/homes/ayats@viperSL4/nix.conf nix-build -A homeConfigurations."ayats@viperSL4".activationPackage $PWD

echo ". $HOME/.config/nix/rc" >> $HOME/.bashrc
```
