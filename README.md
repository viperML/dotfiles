
<!-- Create a centered title -->
<p align="center">
  <h1>viperML/dotfiles</h1>
</p>

# 🗒 About
These are my personal configuration files for my Linux and Windows machines. Feel free to grab anything that you find interesting.


<div align="center">
  <div style="display: flex; align-items: flex-start;">
    <img alt="Desktop screenshot" src=".img/20211118.png" width="100%"/>
  </div>
</div>

# ❄ Installation

This repo provides a [nix flake](https://nixos.wiki/wiki/Flakes) which [NixOS](https://nixos.wiki/wiki/NixOS) and [home-manager](https://github.com/nix-community/home-manager) configuration, along with an overlay for packages.

You can directly reference this flake and import it into your NixOS configuration, or you may want to copy code snippets.

For my personal deployment into a non-NixOS linux system, this is what I do:

```bash
export FLAKE=~/.dotfiles # currently hardcoded into this path
git clone https://github.com/viperML/dotfiles $FLAKE
cd $FLAKE
# build the default package, which is home-manager activation package for user "ayats"
nix-shell --run "nix build"
./result/activate
```


# 💾 Resources
- [flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus): library to help with flakes
- [gytis-ivaskevicius/nixfiles](https://github.com/gytis-ivaskevicius/nixfiles): flake-utils-plus's author flake, from which I ~~stole~~ took heavy inspiration


> Last update of this README: December 2021

# Exported packages

<!-- BEGIN -->

<!-- END -->
