{
  config,
  lib,
  packages,
  pkgs,
  ...
}: let
  mutablePath = "${config.unsafeFlakePath}/modules/home-manager/hyprland/hyprland.conf";
in {
  imports = [
    ../waybar
    ../wayland-compositors
  ];

  programs.waybar.package = packages.hyprland.waybar-hyprland;

  xdg.configFile."hypr/hyprland.conf".text = let
    mkExec = program: program;
  in ''
    source=${mutablePath}

    ${lib.concatMapStringsSep "\n" (n: "bind=SUPER,${toString n},workspace,${toString n}") (lib.range 1 9)}
    ${lib.concatMapStringsSep "\n" (n: "bind=SUPER:SHIFT,${toString n},movetoworkspace,${toString n}") (lib.range 1 9)}

    bind=,XF86AudioRaiseVolume,exec,volume 5%+
    bind=,XF86AudioLowerVolume,exec,volume 5%-
    bind=,Prior,exec,volume 5%+
    bind=,Next,exec,volume 5%-

    bind=SUPER,Return,exec,${mkExec "wezterm"}
    bind=SUPER,O,exec,wezterm start --always-new-process
    bind=SUPER,Space,exec,pkill wofi || ${mkExec "wofi --show drun"}
    bind=,Print,exec,${mkExec "grimblast copy area"}

    exec=${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP XDG_SESSION_TYPE NIXOS_OZONE_WL
    exec=systemctl --user start hyprland-session.target
  '';

  xdg.configFile."hypr/hyprland.conf".onChange = "${packages.self.hyprland}/bin/hyprctl reload";

  home.packages = [
    packages.self.wezterm
    packages.hyprland-contrib.grimblast
  ];

  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "hyprland compositor session";
      BindsTo = ["graphical-session.target"];
      Wants = [
        "graphical-session-pre.target"
        "xdg-desktop-autostart.target"
      ];
      After = [
        "graphical-session-pre.target"
      ];
      Before = [
        "xdg-desktop-autostart.target"
      ];
    };
  };
}
