{
  config,
  lib,
  self',
  pkgs,
  ...
}: let
  mutablePath = "${config.unsafeFlakePath}/modules/home-manager/hyprland/hyprland.conf";
in {
  imports = [../waybar ../wayland-compositors];

  xdg.configFile."hypr/hyprland.conf" = {
    text = let
      mkExec = program: program;
    in ''
      source=${mutablePath}

      ${lib.concatMapStringsSep "\n"
        (n: "bind=SUPER,${toString n},workspace,${toString n}") (lib.range 1 9)}
      ${lib.concatMapStringsSep "\n"
        (n: "bind=SUPER:SHIFT,${toString n},movetoworkspace,${toString n}")
        (lib.range 1 9)}

      bind=,XF86AudioRaiseVolume,exec,volume 5%+
      bind=,XF86AudioLowerVolume,exec,volume 5%-
      bind=,Prior,exec,volume 5%+
      bind=,Next,exec,volume 5%-

      bind=SUPER,O,exec,wezterm start --always-new-process
      bind=SUPER,Space,exec,pkill wofi || ${mkExec "wofi --show drun -I"}
      bind=,Print,exec,${mkExec "grimblast copy area"}

      exec=systemctl --user start hyprland-session.target
      exec=systemctl --user restart kanshi.service
    '';

    # onChange = ''
    #   (
    #     shopt -s nullglob  # so that nothing is done if /tmp/hypr/ does not exist or is empty
    #     for instance in /tmp/hypr/*; do
    #       HYPRLAND_INSTANCE_SIGNATURE=''${instance##*/} ${packages.hyprland.default}/bin/hyprctl reload config-only \
    #         || true  # ignore dead instance(s)
    #     done
    #   )
    # '';
  };

  # home.packages = [packages.self.wezterm packages.hyprland-contrib.grimblast];
  home.packages = [
    pkgs.foot
    self'.packages.wezterm
  ];

  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "hyprland compositor session";
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target" "xdg-desktop-autostart.target"];
      After = ["graphical-session-pre.target"];
      Before = ["xdg-desktop-autostart.target"];
    };
  };
}
