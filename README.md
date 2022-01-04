# viperML/dotfiles

![https://app.cachix.org/cache/viperml](https://img.shields.io/badge/-%E2%9D%84%20built%20with%20nix-blue)
![![GitHub Workflow Status (branch)](https://github.com/viperML/dotfiles/actions/workflows/flake-check.yaml)](https://img.shields.io/github/workflow/status/viperML/dotfiles/Flake%20Check/master?label=flake%20check)
![![GitHub Workflow Status (branch)](https://github.com/viperML/dotfiles/actions/workflows/cachix.yaml)](https://img.shields.io/github/workflow/status/viperML/dotfiles/Cachix/master?label=cachix)

# 🗒 About

These are my personal configuration files for my Linux and Windows machines. Feel free to grab anything that you find interesting.

<div align="center">
  <div style="display: flex; align-items: flex-start;">
    <img alt="Desktop screenshot" src=".img/20211219.png" width="100%"/>
  </div>
</div>

This repo provides a [nix flake](https://nixos.wiki/wiki/Flakes) which [NixOS](https://nixos.wiki/wiki/NixOS) and [home-manager](https://github.com/nix-community/home-manager) configuration, along with an overlay for packages.

You can directly reference this flake and import it into your NixOS configuration, but you may want to copy code snippets instead.

- [modules](modules): NixOS and home-manager modules to import into the configurations. Generic config files are stored into [moudules/misc](modules/misc).
- [overlay](overlay): Nixpkgs/overrides packaged by me for personal use. Can be imported into any flake.
- [lib](lib): Nix utility functions.
- [bin](bin): Various scripts
- [templates](templates): Template files for various projects.
- [.img](.img): A look into the past


# 💾 Resources

- [flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus): library to help with flakes
- [gytis-ivaskevicius/nixfiles](https://github.com/gytis-ivaskevicius/nixfiles): flake-utils-plus's author flake, from which I ~~stole~~ took heavy inspiration

> Last update of this README: January 2022


# 📦 Exported packages

To grab the whole overlay into your flake:

#### flake.nix

```nix
{
  inputs.viperML-dotfiles.url = github:viperML/dotfiles;
  # ...
}
```

#### \<wherever you configure your overlays>

```nix
{
  nixpkgs.overlays = [ inputs.viperML-dotfiles.overlay ];
}
```

<!--BEGIN-->
```json
{
  "x86_64-linux": {
    "any-nix-shell": {
      "description": "fish and zsh support for nix-shell",
      "name": "any-nix-shell-1.2.1",
      "type": "derivation"
    },
    "base-vm": {
      "name": "nixos-disk-image",
      "type": "derivation"
    },
    "lightly": {
      "description": "Lightly is a fork of breeze theme style that aims to be visually modern and minimalistic.",
      "name": "lightly-0.4.1",
      "type": "derivation"
    },
    "multiload-ng": {
      "description": "Modern graphical system monitor for any panel (only systray and standalone builds)",
      "name": "multiload-ng-20210103",
      "type": "derivation"
    },
    "netboot-xyz-images": {
      "description": "netboot.xyz bootloader images, uefi and legacy.",
      "name": "netboot-xyz-images-2.0.53",
      "type": "derivation"
    },
    "papirus-icon-theme": {
      "description": "Papirus icon theme, patched with folder colorscheme",
      "name": "papirus-icon-theme-20211201",
      "type": "derivation"
    },
    "sierrabreezeenhanced": {
      "description": "Fork of BreezeEnhanced to make it (arguably) more minimalistic and informative",
      "name": "sierrabreezeenhanced-1.0.3",
      "type": "derivation"
    }
  }
}
```
<!--END-->
