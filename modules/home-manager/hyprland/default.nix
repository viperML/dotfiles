{
  config,
  pkgs,
  packages,
  lib,
  ...
}: let
  sd-start = pkgs.writeShellScript "hyprland-sd-start" ''
    systemctl --user import-environment; systemctl --user start hyprland-session.target
  '';
  wayland-screenshot = pkgs.writeShellScript "wayland-screenshot" ''
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -
  '';
  volume = pkgs.writeShellScript "volume" ''
    export PATH="$PATH:${pkgs.pamixer}/bin"
    ${pkgs.avizo}/bin/volumectl "$@"
  '';
in {
  home.packages = [
    pkgs.foot
    pkgs.wofi
  ];

  xdg.configFile."hypr/hyprland.conf" = {
    text = ''
      ${lib.fileContents ./hyprland.conf}

      bind=SUPER,Return,exec,foot
      bind=SUPER,Q,killactive,
      bind=SUPER,Z,togglefloating

      bind=SUPER,space,exec,${lib.getExe pkgs.wofi} --show drun
      bind=,Print,exec,${wayland-screenshot}
      bind=,XF86AudioRaiseVolume,exec,${volume} -u up
      bind=,XF86AudioLowerVolume,exec,${volume} -u down
      bind=,XF86AudioMute,exec,${volume} toggle-mute
      exec=${sd-start}
    '';
    onChange = ''
      ${packages.hyprland.default}/bin/hyprctl reload
    '';
  };

  systemd.user.targets."hyprland-session" = {
    Unit = {
      Description = "hyprland compositor session";
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
  };

  systemd.user.services = {
    mako = {
      Unit.Description = "Notification daemon";
      Service.ExecStart = lib.getExe pkgs.mako;
      Install.WantedBy = ["graphical-session.target"];
    };

    gammastep = {
      Unit.Description = "Night time color filter";
      Service.ExecStart = "${lib.getExe pkgs.gammastep} -m wayland -l 40:-2 -t 6500:3000";
      Install.WantedBy = ["graphical-session.target"];
    };

    avizo = {
      Unit.Description = "Volume popup daemon";
      Service.ExecStart = "${pkgs.avizo}/bin/avizo-service";
      Install.WantedBy = ["graphical-session.target"];
    };

    waybar = {
      Unit.Description = "System bar";
      Service.ExecStart = lib.getExe pkgs.waybar;
      Install.WantedBy = ["graphical-session.target"];
    };

    swaybg = {
      Unit.Description = "Wallpaper setter";
      Install.WantedBy = ["graphical-session.target"];
      Service.ExecStart =
        (pkgs.writeShellScript "swaybg" ''
          if [[ -f ~/Pictures/bg ]]; then
            echo "Found image"
            ${lib.getExe pkgs.swaybg} --image ~/Pictures/bg --mode fill
          else
            echo "Image not found"
            ${lib.getExe pkgs.swaybg} --color "#121212"
          fi
        '')
        .outPath;
    };
  };
}
