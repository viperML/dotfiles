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

  # file.xdg_config."hypr/hyprland.conf".source = builtins.toString ./hyprland.conf;
  file.xdg_config."hypr/hyprland.lua".source = builtins.toString ./hyprland.lua;
  file.xdg_config."hypr/monitors.lua".source = builtins.toString ./monitors.lua;

  packages = [
    screenshot
    pkgs.satty
    pkgs.stylua
  ];

  systemd.tmpfiles.dynamicRules = [
    "f ${builtins.toString ./monitors.lua} 0644 {{user}} {{group}} - -"
  ];
}
