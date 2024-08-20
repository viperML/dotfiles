{pkgs, ...}: {
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
  };

  environment.systemPackages = [
    pkgs.vanilla-dmz
    pkgs.kdePackages.discover
    pkgs.kdePackages.ksshaskpass
    pkgs.wl-clipboard-rs
  ];

  services.packagekit = {enable = true;};

  environment.sessionVariables = {
    XCURSOR_THEME = "DMZ-White";
  };

  programs.git.config = {
    credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
  };
}
