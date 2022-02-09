{ config
, pkgs
, lib
, inputs
, ...
}:
{
  # Use flake nixpkgs instead of channels:

  # A standard Nix install will set legacy nix-channels
  # nix-channel --list
  #   nixpkgs https://...
  # These channels are defined in ~/.nix-channels and ~/.nix-defexpr

  # They are also automatically created by home-manager
  # When they exist, they are automatically put into $NIX_PATH (no option to choose)

  # Solution? Nuke them (link to /dev/null)
  # Then put the channels coming from out flake inputs into a sensible location (~/.nix-inputs)
  # Finally, insert them at $NIX_PATH

  home.file =
    lib.mapAttrs' (
      name: value: {
        name = ".nix-inputs/${name}";
        value = { source = value.outPath; };
      }
    )
    inputs;
  home.sessionVariables.NIX_PATH = "nixpkgs=$HOME/.nix-inputs/nixpkgs$\{NIX_PATH:+:$NIX_PATH}";
  home.activation.useFlakeChannels = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.nix-defexpr
    $DRY_RUN_CMD ln -s $VERBOSE_ARG /dev/null $HOME/.nix-defexpr
    $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.nix-channels
    $DRY_RUN_CMD ln -s $VERBOSE_ARG /dev/null $HOME/.nix-channels
  '';
}
