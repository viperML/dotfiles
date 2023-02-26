{pkgs, ...}: {
  services.xserver = {
    enable = true;
    displayManager = {
      gdm.enable = true;
    };
  };

  services.gnome.gnome-keyring.enable = true;

  services.blueman.enable = true;

  environment.systemPackages = [
    pkgs.gnome.seahorse
  ];
}
