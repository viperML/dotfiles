{
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = [
    pkgs.env-viper
  ];

  # Sane default to at least have a static hostId
  networking.hostId = "deadbeef";

  users.mutableUsers = false;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 1w --keep 3";
  };

  nix = {
    package = pkgs.nixVersions.latest;
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
    MANPAGER = "nvim +Man!";
    npm_config_audit = "false";
    npm_config_fund = "false";
    npm_config_update_notifier = "false";
    SYSTEMD_TINT_BACKGROUND = "false";
  };

  time.timeZone = "Europe/Madrid";

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  boot.kernel.sysctl = {
    "kernel.yama.ptrace_scope" = 0;
  };

  security.sudo.enable = false;
  security.sudo.wheelNeedsPassword = false;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units") {
        if (subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
      }
    });
  '';

  systemd.tmpfiles.rules = [
    "d /var/lib/secrets 0700 root root -"
    "z /var/lib/secrets 0700 root root -"
  ];

  virtualisation.vmVariant = {
    services.qemuGuest.enable = true;
    services.xserver.videoDrivers = [ "qxl" ];
    services.spice-vdagentd.enable = true;
    virtualisation = {
      qemu.options = [
        "-vga qxl"
        # "-display spice-app"
        # "-device virtio-serial-pci"
        # "-spice port=5930,disable-ticketing=on"
        # "-device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0"
        # "-chardev spicevmc,id=spicechannel0,name=vdagent"
      ];
      cores = 4;
      memorySize = 1024 * 4;
      resolution.x = 1280;
      resolution.y = 720;
    };
  };
}
