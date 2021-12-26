{ config, pkgs, ... }:

{
  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint # generic
        gutenprintBin
        brlaser # brother
      ];
      webInterface = false;
    };
    avahi.enable = true;
    avahi.nssmdns = true;

  };

  environment.systemPackages = with pkgs; [
    libsForQt5.print-manager
  ];
}
