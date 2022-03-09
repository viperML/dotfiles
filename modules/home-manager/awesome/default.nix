{
  config,
  lib,
  self,
  pkgs,
  ...
}: let
  inherit (builtins) mapAttrs attrValues;
  inherit (pkgs) fetchFromGitHub;

  selfPath =
    if lib.hasAttr "FLAKE" config.home.sessionVariables
    then "${config.home.sessionVariables.FLAKE}/modules/home-manager/awesome"
    else "${self.outPath}/modules/home-manager/awesome";
  finalPath = "${config.home.homeDirectory}/.config/awesome";

  modules = import ./modules.nix {inherit pkgs;};
in {
  home.packages = with pkgs; [
    nitrogen
    rofi
  ];

  systemd.user.tmpfiles.rules =
    map (f: "L+ ${finalPath}/${f} - - - - ${selfPath}/${f}") [
      "rc.lua"
      "helpers.lua"
      "theme.lua"
      "res"
    ]
    ++ attrValues (mapAttrs (name: value: "L+ ${finalPath}/${name} - - - - ${value.outPath}") modules);

  systemd.user.targets.awesome-session = {
    Unit = {
      Description = "awesome window manager session";
      Documentation = ["man:systemd.special(7)"];
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
    };
  };

  systemd.user.services = {
    nitrogen = {
      Unit.Description = "Wallpaper chooser";
      Service.ExecStart = "${pkgs.nitrogen}/bin/nitrogen --restore";
      Install.WantedBy = ["awesome-session.target"];
    };
  };
}
