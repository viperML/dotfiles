{
  pkgs,
  config,
  lib,
  packages,
  ...
}: let
  mutablePath = "${config.unsafeFlakePath}/modules/home-manager/hyprland/hyprland.conf";
in {
  imports = [
    ../waybar
    ../wayland-compositors
  ];

  programs.waybar.package = packages.self.waybar-hyprland;

  xdg.configFile."hypr/hyprland.conf".text = let
    mkExec = program: "systemd-run --slice=app-manual.slice --property=ExitType=cgroup --user --wait --collect ${program}";
  in ''
    source=${mutablePath}

    ${lib.concatMapStringsSep "\n" (n: "bind=SUPER,${toString n},workspace,${toString n}") (lib.range 1 9)}
    ${lib.concatMapStringsSep "\n" (n: "bind=SUPER:SHIFT,${toString n},movetoworkspace,${toString n}") (lib.range 1 9)}

    bind=,XF86AudioRaiseVolume,exec,volume 5%+
    bind=,XF86AudioLowerVolume,exec,volume 5%-
    bind=,Prior,exec,volume 5%+
    bind=,Next,exec,volume 5%-

    bind=SUPER,Return,exec,${mkExec "wezterm start --always-new-process"}
    bind=SUPER,O,exec,wezterm start --always-new-process
    bind=SUPER,Space,exec,pkill wofi || ${mkExec "wofi --show drun"}
    bind=,Print,exec,${mkExec "grimblast copy area"}
  '';

  xdg.configFile."hypr/hyprland.conf".onChange = "hyprctl reload";

  home.packages = [
    packages.self.wezterm
    packages.hyprland-contrib.grimblast
    pkgs.swaybg
  ];

  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "hyprland compositor session";
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
    };
  };

  # systemd.user.services = let
  #   mkService = lib.recursiveUpdate {
  #     Install.WantedBy = ["graphical-session.target"];
  #   };
  # in {
  #   swaybg = {
  #     Unit.Description = "Wallpaper";
  #     Service.ExecStart = "${lib.getExe pkgs.swaybg} --image ${config.home.homeDirectory}/Pictures/wallpaper --mode fill";
  #     Install.WantedBy = ["graphical-session.target"];
  #   };

  #   avizo = mkService {
  #     Unit.Description = "Volume popup daemon";
  #     Service.ExecStart = "${pkgs.avizo}/bin/avizo-service";
  #   };
  # };
}
