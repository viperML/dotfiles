{
  lib,
  pkgs,
  config,
  self,
  ...
}: let
  selfPath =
    if lib.hasAttr "FLAKE" config.home.sessionVariables
    then "${config.home.sessionVariables.FLAKE}/modules/home-manager/rofi"
    else "${self.outPath}/modules/home-manager/rofi";
  finalPath = "${config.home.homeDirectory}/.config/rofi";

  rofi-themes = pkgs.fetchFromGitHub {
    repo = "rofi";
    owner = "adi1090x";
    rev = "aba9eb3d1ad67ade0fdb89b7e4998e69c873a86f";
    sha256 = "1mxf75dywjzrq734a3v525m1hzny2kmxahr15acb4li2qs05wm27";
  };
in {
  home.packages = [pkgs.rofi];

  systemd.user.tmpfiles.rules = [
    "L+ ${finalPath} - - - - ${selfPath}/"
  ];
}
