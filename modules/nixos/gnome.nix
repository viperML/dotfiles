{pkgs, ...}: {
  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome = {
      enable = true;
    };
  };

  environment.systemPackages = [
    pkgs.adw-gtk3
    pkgs.gnome-tweaks
    pkgs.wl-clipboard-rs
  ];

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    SSH_ASKPASS_REQUIRE = "prefer";
    NIXOS_OZONE_WL = "1";
  };

  # programs.git.config = {
  #   credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
  # };
}
