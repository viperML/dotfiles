{
  packages,
  pkgs,
  lib,
  ...
}: {
  system.nixos.label = lib.mkAfter "kde";

  services.xserver = {
    enable = true;
    desktopManager.plasma5 = {
      enable = true;
      runUsingSystemd = true;
    };
    displayManager = {
      sddm.enable = true;
      # defaultSession = "plasmawayland";
      # autoLogin.enable = false;
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  environment.systemPackages = [
    packages.self.reversal-kde
  ];

  # environment.systemPackages = lib.attrValues {
  #   inherit
  #     (pkgs.plasma5Packages)
  #     ark
  #     dolphin-plugins
  #     ffmpegthumbs
  #     gwenview
  #     kcolorchooser
  #     kdegraphics-thumbnailers
  #     kio
  #     kio-extras
  #     plasma-pa
  #     qttools
  #     skanlite
  #     ;

  #   inherit
  #     (packages.self)
  #     adw-gtk3
  #     lightly
  #     reversal-kde
  #     sierrabreezeenhanced
  #     ;
  # };

  systemd.user = {
    services."tray-wait-online" = {
      description = "Wait for KDE system tray to be online";
      serviceConfig = {
        ExecStart = "${pkgs.coreutils-full}/bin/sleep 5";
        Type = "oneshot";
      };
      wantedBy = ["tray.target"];
    };

    targets."tray" = {
      description = "Home-manager common tray target";
      requires = ["xdg-desktop-autostart.target" "tray-wait-online.service"];
      after = ["xdg-desktop-autostart.target" "tray-wait-online.service"];
      bindsTo = ["xdg-desktop-autostart.target"];
      wantedBy = ["xdg-desktop-autostart.target"];
    };
  };
}
