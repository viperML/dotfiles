{args}: let
  modifier = "Mod4";
  inherit (args) pkgs;
  wayland-screenshot = pkgs.writeShellScript "wayland-screenshot" ''
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -
  '';
in {
  gaps = {
    outer = 0;
    inner = 30;
  };

  inherit modifier;

  output = {
    "DP-3" = {
      mode = "2560x1440@119.998Hz";
      bg = "${args.config.home.homeDirectory}/.config/sway/bg fill";
    };
  };

  input = {
    "1133:16514:Logitech_MX_Master_3" = {
      accel_profile = "flat";
      pointer_accel = "0.0";
    };
  };

  bars = args.lib.mkForce [];

  keybindings = args.lib.mkOptionDefault {
    "${modifier}+Return" = "exec ${args.pkgs.wezterm}/bin/wezterm";
    "${modifier}+q" = "kill";
    "${modifier}+Shift+r" = "reload";
    "${modifier}+space" = "exec ${args.pkgs.wofi}/bin/wofi -S drun";
    "${modifier}+z" = "floating toggle";
    "${modifier}+e" = "exec ${args.pkgs.gnome.nautilus}/bin/nautilus";
    "Print" = "exec ${wayland-screenshot}";
  };

  window = {
    # titlebar = true;
    border = 0;
  };
}
