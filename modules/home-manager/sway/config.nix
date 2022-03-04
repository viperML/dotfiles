{
  pkgs,
  lib,
}: let
  modifier = "Mod4";
in {
  gaps = {
    outer = 5;
  };

  inherit modifier;

  output = {
    DP-3 = {mode = "2560x1440@119.998Hz";};
  };

  keybindings = lib.mkOptionDefault {
    "${modifier}+Return" = "exec ${pkgs.wezterm}/bin/wezterm";
    "${modifier}+q" = "kill";
    "${modifier}+Shift+r" = "reload";
    "${modifier}+space" = "exec ${pkgs.wofi}/bin/wofi -S drun";
  };
}
