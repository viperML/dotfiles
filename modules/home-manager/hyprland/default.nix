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
      ];
      text = ''
        wpctl set-volume @DEFAULT_AUDIO_SINK@ "$@"
        pamixer --get-volume > "$XDG_RUNTIME_DIR"/wob.sock
      '';
    };
  in ''
    source=${mutablePath}

    bind=,XF86AudioRaiseVolume,exec,${lib.getExe volume} 5%+
    bind=,XF86AudioLowerVolume,exec,${lib.getExe volume} 5%-
    bind=,Prior,exec,${lib.getExe volume} 5%+
    bind=,Next,exec,${lib.getExe volume} 5%-
  '';

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
