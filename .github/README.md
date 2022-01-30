<h1 align="center">viperML/dotfiles</h1>


<p align="center">
  <a href="https://github.com/viperML/dotfiles/actions/workflows/flake-check.yaml">
    <img alt="GitHub Workflow Status" src="https://img.shields.io/github/workflow/status/viperML/dotfiles/Flake%20check?label=flake%20check">
  </a>
  <a href="https://github.com/viperML/dotfiles/actions/workflows/flake-cache.yaml">
    <img alt="GitHub Workflow Status" src="https://img.shields.io/github/workflow/status/viperML/dotfiles/Flake%20check?label=cachix">
  </a>
</p>

# 🗒 About

These are my personal configuration files for my Linux and Windows machines. Feel free to grab anything that you find interesting.

<div align="center">
  <div style="display: flex; align-items: flex-start;">
    <img alt="Desktop screenshot" src="../.img/20211219.png" width="100%"/>
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

You can either:
- Pull the whole package into nixpkgs, and reference any package:


```nix
# flake.nix
{
  # ...
  inputs.viperML-dotfiles.url = github:viperML/dotfiles;

  outputs  = inputs@{ ... }: {
    nixosConfigurations.<hostname> = nixpkgs.lib.nixosSystem {
      # ...
      modules = [
        {
          nixpkgs.overlays = [
            inputs.viperML-dotfiles.overlay-pkgs
          ];
          environment.systemPackages = [
            <pkg>
          ];
        }
      ];
    };
  }
}
```

- Or reference specific packages, such as:

```nix
# configuration.nix
{ inputs, ... }: {
  environment.systemPackages = [
    # ...
    inputs.viperML-dotfiles.pkgs.x86_64-linux.<pkg>`
  ];
}
```
Packages are built and pushed to a public cachix cache, according to [.github/build-pkgs.sh](build-pkgs.sh). You can use the binary cache with:

```nix
# configuration.nix
{ config, pkgs, ... }: {
  nix.extraOptions = ''
    extra-substituters = https://viperml.cachix.org
    extra-trusted-public-keys = viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8=
  '';
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
    "disconnect-tracking-protection": {
      "description": "Tracking protection lists and services",
      "name": "disconnect-tracking-protection-20220112",
      "type": "derivation"
    },
    "koi-fork": {
      "description": "Theme scheduling for the KDE Plasma Desktop",
      "name": "koi-20201128",
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
    "plasma-applet-splitdigitalclock": {
      "description": "Split Digital Clock",
      "name": "plasma-applet-splitdigitalclock-unstable-2021-12-27",
      "type": "derivation"
    },
    "plasma-theme-switcher": {
      "description": "Quickly apply KDE Plasma color schemes and widget styles from the command-line",
      "name": "plasma-theme-switcher-develop-20201129",
      "type": "derivation"
    },
    "reversal-kde": {
      "description": "Reversal kde is a materia Design theme for KDE Plasma desktop.",
      "name": "reversal-kde-20220101",
      "type": "derivation"
    },
    "sierrabreezeenhanced": {
      "description": "Fork of BreezeEnhanced to make it (arguably) more minimalistic and informative",
      "name": "sierrabreezeenhanced-1.0.3",
      "type": "derivation"
    },
    "stevenblack-hosts": {
      "description": "Unified hosts file with base extensions",
      "name": "stevenblack-hosts-unstable-2022-01-25",
      "type": "derivation"
    }
  }
}
```
<!--END-->
