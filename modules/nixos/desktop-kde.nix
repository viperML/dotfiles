{ config, pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      displayManager = {
        sddm = {
          enable = true;
          # autoLogin.relogin = true;
          settings.Wayland.SessionDir = "${pkgs.plasma5Packages.plasma-workspace}/share/wayland-sessions";
        };
        # autoLogin.user = "${config.users.users.mainUser.name}";
        # autoLogin.enable = true;
      };
      desktopManager.plasma5 = {
        enable = true;
        runUsingSystemd = true;
      };
    };
  };

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  programs.xwayland.enable = true;

  environment.systemPackages = with pkgs; [
    libsForQt5.bismuth
    libsForQt5.plasma-pa
    libsForQt5.qtstyleplugin-kvantum
    lightly
    sierrabreezeenhanced
    libsForQt5.ark
    libsForQt5.ffmpegthumbs
    libsForQt5.kdegraphics-thumbnailers
    libsForQt5.filelight
    libsForQt5.gwenview
    libsForQt5.kwalletmanager
    caffeine-ng

    wezterm
    egl-wayland
  ];
}
