{ config
, pkgs
, lib
, ...
}:
{
  services = {
    printing = {
      enable = true;
      drivers =
        with pkgs;
        [
          gutenprint
          # generic
          gutenprintBin
          brlaser
          # brother
        ];
      webInterface = false;
    };
    avahi.enable = true;
    avahi.nssmdns = true;
  };

  environment.systemPackages = lib.mkIf config.services.xserver.desktopManager.plasma5.enable [ pkgs.libsForQt5.print-manager ];
}
