{
  pkgs,
  lib,
  ...
}: let
  modifier = "Mod4";

  volume = pkgs.writeShellApplication {
    name = "volume";
    runtimeInputs = with pkgs; [
      pamixer
      avizo
    ];
    text = ''
      volumectl "$@"
    '';
  };

  wayland-screenshot = pkgs.writeShellApplication {
    name = "wayland-screenshot";
    runtimeInputs = with pkgs; [
      grim
      slurp
      swappy
    ];
    text = ''
      grim -g "$(slurp)" - | swappy -f -
    '';
  };
in {
  wayland.windowManager.sway.config = {
    gaps = {
      outer = 0;
      inner = 10;
    };

    inherit modifier;

    output = lib.genAttrs ["DP-1" "DP-2" "DP-3"] (_: {
      adaptive_sync = "off";
    });

    input = {
      "type:pointer" = {
        accel_profile = "flat";
        pointer_accel = "0.0";
      };
      "type:keyboard" = {
        xkb_layout = "es";
        # xkb_options =
      };
    };

    bars = lib.mkForce [];

    keybindings = lib.mkOptionDefault rec {
      "${modifier}+Return" = "exec wezterm";
      "${modifier}+q" = "kill";
      "${modifier}+Shift+r" = "reload";
      "${modifier}+space" = "exec ${pkgs.wofi}/bin/wofi -S drun -I --define=image_size=30 --style=${./style.css}";
      "${modifier}+z" = "floating toggle";
      "${modifier}+e" = "exec dolphin";
      "Print" = "exec ${lib.getExe wayland-screenshot}";
      XF86AudioRaiseVolume = "exec ${lib.getExe volume} -u up";
      XF86AudioLowerVolume = "exec ${lib.getExe volume} -u down";
      "Prior" = XF86AudioRaiseVolume; # PageDown
      "Next" = XF86AudioLowerVolume; # PageUp
      "XF86AudioMute" = "exec ${volume} toggle-mute";
      "XF86AudioMicMute" = "exec ${volume} -m toggle-mute";
    };

    window = {
      titlebar = true;
      border = 0;
    };

    colors = let
      accent = "#81a2be";
    in rec {
      focused = rec {
        border = accent;
        indicator = border;
        background = accent;
        childBorder = border;
        text = "#121212";
      };
      unfocused = rec {
        border = "#3A3A3A";
        indicator = border;
        background = border;
        childBorder = border;
        text = "#aaaaaa";
      };
      focusedInactive = unfocused;
    };

    fonts = {
      names = [
        "Roboto"
        "sans-serif"
      ];
      size = 10.0;
    };

    seat."*" = {
      xcursor_theme = "Vanilla-DMZ 24";
    };
  };

  wayland.windowManager.sway.extraConfig = ''
    title_align center
    titlebar_padding 7

    corner_radius 11
  '';
}
