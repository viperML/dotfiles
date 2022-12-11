args: let
  modifier = "Mod4";
  inherit (args) pkgs;
  wayland-screenshot = pkgs.writeShellScript "wayland-screenshot" ''
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -
  '';
  volume = pkgs.writeShellScript "volume" ''
    export PATH="$PATH:${pkgs.pamixer}/bin"
    ${pkgs.avizo}/bin/volumectl "$@"
  '';

  nocolor = "#FF0000";
in {
  config = {
    gaps = {
      outer = 0;
      inner = 10;
    };

    inherit modifier;

    output = {
      # "DP-3" = {
      #   mode = "2560x1440@144Hz";
      #   # bg = "${args.config.home.homeDirectory}/.config/sway/bg fill";
      #   adaptive_sync = "on";
      # };
    };

    input = {
      "type:pointer" = {
        accel_profile = "flat";
        pointer_accel = "0.0";
      };
      "type:keyboard" = {
        xkb_layout = "es";
      };
    };

    bars = args.lib.mkForce [];

    keybindings = args.lib.mkOptionDefault {
      "${modifier}+Return" = "exec tym";
      "${modifier}+q" = "kill";
      "${modifier}+Shift+r" = "reload";
      "${modifier}+space" = "exec ${pkgs.wofi}/bin/wofi -S drun";
      "${modifier}+z" = "floating toggle";
      "${modifier}+e" = "exec dolphin";
      "Print" = "exec ${wayland-screenshot}";
      "XF86AudioRaiseVolume" = "exec ${volume} -u up";
      "XF86AudioLowerVolume" = "exec ${volume} -u down";
      "XF86AudioMute" = "exec ${volume} toggle-mute";
      "XF86AudioMicMute" = "exec ${volume} -m toggle-mute";
    };

    window = {
      # titlebar = true;
      border = 8;
    };

    colors = {
      focused = rec {
        border = "#83abd4AA";
        indicator = border;
        background = nocolor;
        childBorder = border;
        text = nocolor;
      };
      unfocused = rec {
        border = "#444444AA";
        indicator = border;
        background = nocolor;
        childBorder = border;
        text = nocolor;
      };
      focusedInactive = rec {
        border = "#444444AA";
        indicator = border;
        background = nocolor;
        childBorder = border;
        text = nocolor;
      };
    };
  };

  extraConfig = ''
  '';
}
