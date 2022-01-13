{ config, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [ river ];
  };
  programs.xwayland.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
}

