{ pkgs, lib, ... }:
let
  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    text = lib.fileContents ./screenshot;
    runtimeInputs = with pkgs; [
      coreutils
      slurp
      grim
      satty
      xdg-user-dirs
    ];
  };
in
{
  imports = [
    ../wayland-compositors
  ];

  file.xdg_config."hypr/hyprland.conf".source = builtins.toString ./hyprland.conf;

  packages = [
    screenshot
    pkgs.satty
  ];

  systemd.tmpfiles.dynamicRules = [
    "f {{xdg_config_home}}/hypr/monitors.conf 0644 {{user}} {{group}} - -"
  ];
}
