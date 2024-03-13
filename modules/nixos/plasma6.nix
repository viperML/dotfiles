{ pkgs, packages, ... }: {
  services.xserver = {
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
  ];

  services.packagekit = {
    enable = true;
  };

  programs.git.config = {
    credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
  };
}
