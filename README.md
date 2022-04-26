<h1 align="center">viperML/dotfiles</h1>


<p align="center">
  <a href="https://github.com/viperML/dotfiles/actions/workflows/flake-build.yaml">
  <img alt="check" src="https://img.shields.io/github/workflow/status/viperML/dotfiles/flake-build?label=flake%20build">
  </a>
  <a href="https://github.com/viperML/dotfiles/actions/workflows/neovim-bundle.yaml">
  <img alt="cache" src="https://img.shields.io/github/workflow/status/viperML/dotfiles/neovim-bundle?label=neovim%20bundle">
  </a>
</p>

# 🗒 About

These are my personal configuration files for my Linux and Windows machines. Feel free to grab anything that you find interesting.

<div align="center">
  <div style="display: flex; align-items: flex-start;">
    <img alt="Desktop screenshot" src="./misc/img/20220222.png" width="100%"/>
  </div>
</div>


A [nix flake](https://nixos.wiki/wiki/Flakes) is provided, whith [NixOS](https://nixos.wiki/wiki/NixOS) and [home-manager](https://github.com/nix-community/home-manager) configurations.

You can directly reference this flake and import it into your NixOS configuration, but you may want to copy code snippets instead.

- [modules](modules): common pieces of NixOS or Home-manager configuration
- [hosts](hosts): host-specific configuration
- [packages](packages): package definitions (see next section)
- [lib](lib): utility functions.
- [bin](bin): various scripts
- [misc](misc): anything else
- [misc/img](misc/img): a look into the past


# 💾 Resources

Other configurations from where I learned and copied:

- [flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus)
- [gytis-ivaskevicius/nixfiles](https://github.com/gytis-ivaskevicius/nixfiles)
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles)
- [Mic92/dotfiles](https://github.com/Mic92/dotfiles)
- [colemickens/nixcfg](https://github.com/colemickens/nixcfg)
- [nuxshed/dotfiles](https://github.com/nuxshed)
- [NobbZ/nixos-config](https://github.com/NobbZ/nixos-config)


# 📦 Exported packages

Install directly from the `packages` output. For example:

```nix
# flake.nix
{
  inputs.viperML-dotfiles.url = github:viperML/dotfiles;
  # Override my nixpkgs, binary cache may have less hits
  inputs.viperML-dotfiles.inputs.nixpkgs.follows = "nixpkgs";
}

# configuration.nix
{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.viperML-dotfiles.packages.${pkgs.system}.thePkgName
  ];
}
```

A package cache is provided:

```nix
# configuration.nix
  nix.extraOptions = ''
    extra-substituters = https://viperml.cachix.org
    extra-trusted-public-keys = viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8=
  '';
```

# Neovim distribution

Neovim is bundled with all the configuration and plugins, such that it doesn't require any storage in the user's home directory.

To run it:

```console
nix run github:viperML/dotfiles#neovim -- /path/to/file
```

I also build .DEB and .RPM bundles, that you can [download from CI](https://github.com/viperML/dotfiles/actions/workflows/neovim-bundle.yaml)
