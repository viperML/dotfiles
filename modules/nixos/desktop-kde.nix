{ config, pkgs, lib, ... }:

{
  services.xserver = {
    desktopManager.plasma5 = {
      enable = true;
      runUsingSystemd = true;
    };
    displayManager.defaultSession = "plasma";
    displayManager.autoLogin =
      let
        my-users = builtins.attrNames (pkgs.lib.filterAttrs (name: value: value.isNormalUser == true) config.users.users);
      in
      {
        enable = (builtins.length my-users == 1);
      };
  };

  environment.systemPackages = with pkgs; [
    # Theming
    lightly
    sierrabreezeenhanced

    # Extend
    libsForQt5.bismuth
    libsForQt5.plasma-pa
    libsForQt5.ark
    libsForQt5.ffmpegthumbs
    libsForQt5.kdegraphics-thumbnailers
    libsForQt5.filelight
    libsForQt5.gwenview
    libsForQt5.kwalletmanager
    caffeine-ng
    reversal-kde
  ];

  security.pam.services =
    lib.mkIf
      config.services.xserver.displayManager.gdm.enable
      { gdm-password.enableKwallet = true; };
}
