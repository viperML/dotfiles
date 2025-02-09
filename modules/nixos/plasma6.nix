{
  pkgs,
  config,
  lib,
  ...
}: {
  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm.enable = true;
      defaultSession = "plasma";
    };
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    SSH_ASKPASS_REQUIRE = "prefer";
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = [
    pkgs.vanilla-dmz
    pkgs.kdePackages.ksshaskpass
    pkgs.wl-clipboard-rs
  ];

  environment.sessionVariables = {
    XCURSOR_THEME = "DMZ-White";
  };

  programs.git.config = {
    credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
  };

  programs.kde-pim = let
    cfg = config.programs.kde-pim.enable;
  in {
    enable = lib.mkOverride 999 false;
    kmail = lib.mkIf cfg true;
    kontact = lib.mkIf cfg true;
    merkuro = lib.mkIf cfg true;
  };
}
