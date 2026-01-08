{
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    env-viper
    net-tools
    tcpdump
    libcgroup
    nodejs
    pnpm
    prettier
    litecli
    serve
    zellij
  ];

  # Sane default to at least have a static hostId
  networking.hostId = "deadbeef";

  users.mutableUsers = false;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 1w --keep 3";
    # package = inputs'.nh.packages.default;
  };

  nix = {
    package = pkgs.nixVersions.latest;
    # package = self'.packages.nix;
    daemonCPUSchedPolicy = "idle";
    settings = lib.mkMerge [
      {
        extra-experimental-features = [
          "pipe-operators"
        ];
        flake-registry = "/etc/nix/registry.json";
      }
      (import ../../misc/nix-conf-privileged.nix)
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
    npm_config_audit = "false";
    npm_config_fund = "false";
    npm_config_update_notifier = "false";
  };

  time.timeZone = "Europe/Madrid";

  programs.git = {
    enable = true;
    lfs.enable = true;
  };
}
