{
  config,
  pkgs, lib,
  ...
}: {

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 1w --keep 3";
    # package = inputs'.nh.packages.default;
  };

  nix = {
    # package = self'.packages.nix;
    daemonCPUSchedPolicy = "idle";
    settings = lib.mkMerge [
      (import ../../misc/nix-conf.nix)
      (import ../../misc/nix-conf-privileged.nix)
      { "flake-registry" = "/etc/nix/registry.json"; }
    ];
    channel.enable = false;
    nixPath = [ "nixpkgs=/etc/nixpkgs" ];
    # FIXME: Should use a `path` entry using the narHash from npins
    registry.nixpkgs.to = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = (import ../../npins).nixpkgs.revision;
    };
  };

  environment.etc.nixpkgs.source = pkgs.path;

  environment.defaultPackages = [ ];

  environment.sessionVariables = {
    EDITOR = "nvim";
    # NIXPKGS_CONFIG = lib.mkForce "";
  };

  environment.systemPackages = with pkgs; [
    env-viper
  ];

  time.timeZone = "Europe/Madrid";

  programs.git = {
    enable = true;
    lfs.enable = true;
  };
}
