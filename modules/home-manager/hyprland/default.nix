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

  programs.waybar.package = packages.hyprland.waybar-hyprland;

  xdg.configFile."hypr/hyprland.conf".text = let
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
  in ''
    source=${mutablePath}

    bind=,XF86AudioRaiseVolume,exec,${lib.getExe volume} -u up
    bind=,XF86AudioLowerVolume,exec,${lib.getExe volume} -u down
    bind=,Prior,exec,${lib.getExe volume} -u up
    bind=,Next,exec,${lib.getExe volume} -u down
  '';

  home.packages = [
    packages.self.wezterm
    pkgs.wofi
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
