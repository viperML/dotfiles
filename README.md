<h1 align="center">viperML/dotfiles</h1>


<p align="center">
  <a href="https://github.com/viperML/dotfiles/actions/workflows/flake-build.yaml">
  <img alt="check" src="https://img.shields.io/github/actions/workflow/status/viperML/dotfiles/flake-build.yaml?branch=master&label=flake-build">
  </a>
</p>

# 🗒 About

These are my personal configuration files for my Linux and Windows machines. Feel free to grab anything that you find interesting.

- [packages](packages): package definitions (see next section)
- [modules](modules): common pieces of nixos or home-manager configuration
- [hosts](hosts): nixos configurations
- [flake](flake): core flake scaffolding and maintenance scripts
- [misc](misc): anything else
- [misc/img](misc/img): a look into the past



<div align="center">
  <div style="display: flex; align-items: flex-start;">
    <img alt="Desktop screenshot" src="./misc/img/20230809.png" width="100%"/>
  </div>
</div>



# 📦 Exported packages

Run packages directly with:

```console
nix run github:viperML/dotfiles#name
```

Or install from the `packages` output. For example:

```nix
# flake.nix
{
  inputs.viperML-dotfiles.url = "github:viperML/dotfiles";

  # Override my nixpkgs
  inputs.viperML-dotfiles.inputs.nixpkgs.follows = "nixpkgs";
}

# configuration.nix
{ pkgs, inputs, ... }: {
  environment.systemPackages = [
    inputs.viperML-dotfiles.packages.${pkgs.system}.name
  ];
}
```

Binary cache is provided through cachix. Every commit is built on GitHub Actions

```nix
# configuration.nix
{
  nix.settings = {
    extra-substituters = "https://viperml.cachix.org";
    extra-trusted-public-keys = "viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8=";
  };
}
```

# 💾 Resources

Other configurations from where I learned and copied, in no particular order:

- [NobbZ/nixos-config](https://github.com/NobbZ/nixos-config)
- [Mic92/dotfiles](https://github.com/Mic92/dotfiles)
- [colemickens/nixcfg](https://github.com/colemickens/nixcfg)
- [privatevoid-net/privatevoid-infrastructure](https://github.com/privatevoid-net/privatevoid-infrastructure)
- [nuxshed/dotfiles](https://github.com/nuxshed)
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles)
- [gytis-ivaskevicius/nixfiles](https://github.com/gytis-ivaskevicius/nixfiles)

