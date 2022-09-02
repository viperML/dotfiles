```console
nix build .#homeConfigurations.ayats.config.home.wsl.tarball
cp -fvL result/wsl.tar.gz ~/Desktop/
wsl --import Alpinix C:\WSL\Alpinix C:\Users\ayats\Desktop\wsl.tar.gz
```
