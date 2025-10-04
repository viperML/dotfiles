{
  pkgs,
  ...
}:
{
  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm.enable = true;
      # defaultSession = "plasma";
    };
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    SSH_ASKPASS_REQUIRE = "prefer";
    NIXOS_OZONE_WL = "1";

    XCURSOR_THEME = "DMZ-White";
  };

  environment.systemPackages = [
    pkgs.vanilla-dmz
    pkgs.kdePackages.ksshaskpass
  ];

  maid.sharedModules = [
    ../maid/plasma6
  ];

  programs.ssh.startAgent = true;

  # programs.git.config = {
  #   credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
  # };
}
