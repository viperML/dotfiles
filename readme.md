<h1 align="center">viperML/dotfiles</h1>


# 🗒 About

These are my personal configuration files for my Linux and Windows machines. Feel free to grab anything that you find interesting.



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
