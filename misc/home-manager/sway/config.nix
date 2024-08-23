{
  pkgs,
  lib,
  ...
}: let
  modifier = "Mod4";

  wayland-screenshot = pkgs.writeShellApplication {
    name = "wayland-screenshot";
    runtimeInputs = with pkgs; [grim slurp swappy];
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
      # max_render_time = "6";
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

    keybindings = let
      # Doesn't pass env properly
      # mkExec = program: "exec systemd-run --slice=manual.slice --property=ExitType=cgroup --user --wait --collect -E PATH ${program}";
      mkExec = program: "exec ${program}";
    in
      lib.mkOptionDefault rec {
        "${modifier}+Return" = mkExec "wezterm start --always-new-process";
        "${modifier}+Shift+Return" = "exec wezterm";
        "${modifier}+q" = "kill";
        "${modifier}+Shift+r" = "reload";
        "${modifier}+space" = "exec pkill wofi || ${mkExec "wofi --show drun -I"}";
        "${modifier}+z" = "floating toggle";
        "${modifier}+e" = mkExec "dolphin";
        "${modifier}+Shift+S" = "exec ${lib.getExe wayland-screenshot}";
        XF86AudioRaiseVolume = "exec volume 5%+";
        XF86AudioLowerVolume = "exec volume 5%-";
        "Prior" = XF86AudioRaiseVolume; # PageDown
        "Next" = XF86AudioLowerVolume; # PageUp
        "XF86AudioMute" = "exec volume toggle-mute";
        "XF86AudioMicMute" = "exec volume -m toggle-mute";
        "Ctrl+Alt+Delete" = "exec power-menu";
      };

    window = {
      titlebar = true;
      border = 0;
    };

    colors = let
      accent = "#ababab";
    in rec {
      focused = rec {
        border = accent;
        indicator = border;
        background = accent;
        childBorder = border;
        text = "#121212";
      };
      unfocused = rec {
        border = "#0F0F0F";
        indicator = border;
        background = border;
        childBorder = border;
        text = "#aaaaaa";
      };
      focusedInactive = unfocused;
    };

    fonts = {
      names = ["Roboto" "sans-serif"];
      size = 10.0;
    };

    seat."*" = {xcursor_theme = "DMZ-White 24";};
  };

  wayland.windowManager.sway.extraConfig = ''
    title_align center
    titlebar_padding 7
    # FIXME Available on sway 1.9
    # primary_selection disabled

    smart_gaps on

    for_window [app_id="Waydroid"] floating enable
  '';
}
