{
  config,
  pkgs,
  lib,
  self,
  inputs,
  packages,
  ...
}: (lib.mkMerge [
  {
    system.stateVersion = "21.11";
    system.configurationRevision = self.rev or null;
    time.timeZone = "Europe/Madrid";

    documentation = {
      man.enable = true;
      doc.enable = false;
      info.enable = false;
      nixos.enable = false;
    };

    nix = {
      extraOptions = ''
        ${builtins.readFile ../../misc/nix.conf}
      '';
      gc = {
        automatic = true;
        dates = "04:00";
        # options = "--delete-older-than 7d";
        options = "-d";
      };
    };

    security.sudo.extraConfig = ''
      Defaults pwfeedback
      Defaults env_keep += "EDITOR PATH"
      Defaults timestamp_timeout=300
      Defaults lecture=never
      Defaults passprompt="[31msudo: password for %p@%h, running as %U:[0m "
    '';

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

    xdg.portal = {
      enable = true;
      gtkUsePortal = true;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs self packages;};
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
