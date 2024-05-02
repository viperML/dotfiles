{pkgs, ...}: {
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    # publish = {
    #   enable = true;
    #   userServices = true;
    # };
  };

  services.printing = {
    enable = true;
    # listenAddresses = [ "*:631" ];
    # allowFrom = [ "all" ];
    # browsing = true;
    # defaultShared = true;
    drivers = with pkgs; [
      gutenprint
      hplipWithPlugin
      postscript-lexmark
      samsung-unified-linux-driver
      splix
      brlaser
      cnijfilter2
    ];
  };

  # networking.firewall = {
  #   allowedTCPPorts = [ 631 ];
  #   allowedUDPPorts = [ 631 ];
  # };
}
