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
  ];
}
