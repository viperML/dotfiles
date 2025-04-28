let
  sources = import ./npins;
  pkgs = import sources.nixpkgs {
    config.allowUnfree = true;
  };
in
  pkgs
  
