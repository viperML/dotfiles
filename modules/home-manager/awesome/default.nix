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
    lxrandr
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

  programs.autorandr = {
    enable = true;
    profiles = {
      "gen6" = {
        fingerprint."DP-2" = "00ffffffffffff003669a73f86030000091d0104a53c22783b1ad5ae5048a625125054bfcf00d1c0714f81c0814081809500b3000101695e00a0a0a029503020b80455502100001af8e300a0a0a032500820980455502100001e000000fd003090dede3c010a202020202020000000fc004d5349204d41473237314351520169020320714d0102031112130f1d1e0e901f04230917078301000065030c0010006fc200a0a0a055503020350055502100001a5a8700a0a0a03b503020350055502100001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b8";
        config."DP-2" = {
          crtc = 0;
          mode = "2560x1440";
          position = "0x0";
          rate = "144.00";
        };
      };
    };
  };
}
