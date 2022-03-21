{
  config,
  pkgs,
  lib,
  self,
  inputs,
  ...
}: (lib.mkMerge [
  {
    services = {
      pipewire = {
        enable = true;
        pulse.enable = true;
      };

      journald.extraConfig = ''
        Storage=volatile
      '';

      ananicy.enable = true;
      thermald.enable = true;
      udev.packages = [pkgs.android-udev-rules];
      flatpak.enable = true;
    };

    # replaced by pipewire
    hardware.pulseaudio.enable = false;

    environment.systemPackages = with pkgs; [
      # CLI to be found by default in other distros
      file
      xsel
      pciutils
      wget
      libarchive
      lsof
      usbutils
      # Icons
      (g-papirus-icon-theme.override {color = "palebrown";})
    ];

    nix = {
      gc = {
        automatic = true;
        dates = "04:00";
        # options = "--delete-older-than 7d";
        options = "-d";
      };
    };

    xdg.portal.enable = true;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs self;};
      sharedModules = [
        {
          home.stateVersion = lib.mkForce config.system.stateVersion;
        }
      ];
    };
  }
  (lib.mkIf config.services.xserver.displayManager.gdm.enable {
    # Fixes GDM autologin in Wayland
    # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;
  })
])
