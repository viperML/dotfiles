{
  config,
  pkgs,
  lib,
  self,
  ...
}: let
  selfPath =
    if lib.hasAttr "FLAKE" config.home.sessionVariables
    then "${config.home.sessionVariables.FLAKE}/modules/home-manager/emacs-doom"
    else "${self.outPath}/modules/home-manager/emacs-doom";

  emacsPath = "${config.home.homeDirectory}/.emacs.d";
in {
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
    emacsPackage = pkgs.emacsPgtkGcc;
    extraConfig = ''
      (load "~/.emacs.d/main.el")
      (setq custom-file "~/.emacs.d/custom.el")
      (load custom-file)
    '';
    emacsPackagesOverlay = efinal: eprev: {
      rose-pine-emacs = eprev.trivialBuild {
        pname = "rose-pine-emacs";
        ename = "rose-pine-emacs";
        version = "unstable-2021-02-16";
        buildInputs = with eprev; [autothemer];
        src = pkgs.fetchFromGitHub {
          owner = "thongpv87";
          repo = "rose-pine-emacs";
          rev = "a582160bb77abb3730a1d33a0a02b09fb24ba188";
          sha256 = "0vrfks77yrx657gigw24xcdv7qn92p66c34iv77q3d69571nf4gk";
        };
      };
    };
  };

  systemd.user.tmpfiles.rules = map (f: "L+ ${emacsPath}/${f} - - - - ${selfPath}/${f}") [
    "main.el"
    "custom.el"
  ];
}
