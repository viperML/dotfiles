{ pkgs, ... }:
{
  services = {
    displayManager.sddm.enable = true;
    desktopManager.plasma6 = {
      enable = true;
    };
  };

  programs.ssh.startAgent = true;

  environment.systemPackages = with pkgs; [ ];

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    # XCURSOR_THEME = "DMZ-White";
    # XCURSOR_SIZE = "128";
  };
}
