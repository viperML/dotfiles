args @ {
  config,
  lib,
  self,
  pkgs,
  packages,
  ...
}: let
  inherit (builtins) mapAttrs attrValues;
  inherit (pkgs) fetchFromGitHub;

  selfPath =
    if lib.hasAttr "FLAKE" config.home.sessionVariables
    then "${config.home.sessionVariables.FLAKE}/modules/home-manager/awesome"
    else "${self.outPath}/modules/home-manager/awesome";
  finalPath = "${config.home.homeDirectory}/.config/awesome";

  modules = import ./modules.nix pkgs;

  mkService = lib.recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["awesome-session.target"];
  };
in {
  home.packages = attrValues {
    inherit
      (pkgs)
      nitrogen
      lxrandr
      # Required by keybinds
      
      pulseaudio
      ;

    inherit
      (pkgs.xorg)
      # Required by bling
      
      xwininfo
      ;

    inherit
      (packages.self)
      adw-gtk3
      ;
  };

  xdg.configFile."awesome".source =
    (pkgs.runCommandLocal "awesome-config" {} ''
      set -x
      mkdir -p $out
      for f in ${self}/modules/home-manager/awesome/*; do
        n=$(basename $f)
        ln -sfvT ${config.home.sessionVariables.FLAKE}/modules/home-manager/awesome/$n $out/$n
      done
      ${lib.concatStringsSep "\n" (builtins.attrValues (builtins.mapAttrs (name: path: "ln -sfvT ${path} $out/${name}") modules))}
    '')
    .outPath;

  home.file.".Xresources".text = ''
    Xft.dpi: 96
  '';

  systemd.user.targets.awesome-session = {
    Unit = {
      Description = "awesome window manager session";
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
    };
  };

  systemd.user.services = {
    nitrogen = mkService {
      Unit.Description = "Wallpaper chooser";
      Service.ExecStart = "${pkgs.nitrogen}/bin/nitrogen --restore";
    };
    nm-applet = mkService {
      Unit.Description = "Network manager applet";
      Service.ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
    };
    # caffeine = mkService {
    #   Unit.Description = "Caffeine applet";
    #   Service.ExecStart = "${pkgs.caffeine-ng}/bin/caffeine";
    # };
    autorandr-boot = mkService {
      Unit.Description = "Load autorandr on boot";
      Service.ExecStart = "${pkgs.autorandr}/bin/autorandr --change";
    };
    polkit-agent = mkService {
      Unit.Description = "GNOME polkit agent";
      Service.ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    };

    redshift = let
      redshift-conf = pkgs.writeText "redshift-conf" ''
        [redshift]
        location-provider=manual
        temp-day=6500
        temp-night=3500
        transition=1
        adjustment-method=randr
        [manual]
        lat=41
        lon=-3
      '';
    in
      mkService {
        Unit.Description = "Night color filter";
        Service.ExecStart = "${pkgs.redshift}/bin/redshift-gtk -c ${redshift-conf}";
      };
    xob = let
      pyenv = pkgs.python3.withPackages (p3: [p3.pulsectl]);
      xob-daemon = pkgs.writeShellScript "xob-daemon" ''
        ${pyenv}/bin/python ${./xob/xob_receiver.py} | ${pkgs.xob}/bin/xob -c ${./xob/xob.cfg}
      '';
    in
      mkService {
        Unit.Description = "Visual overlay of current volume";
        Service.ExecStart = xob-daemon.outPath;
        Unit.After = ["pipewire-pulse.service"];
      };
  };

  programs.autorandr = {
    enable = true;
    profiles = {
      "gen6" = let
        displays = [
          # "DP-1"
          # "DP-2"
          # "DP-3"
          "DP-4"
        ];
      in {
        fingerprint = lib.genAttrs displays (d: "*");
        config = lib.genAttrs displays (d: {
          crtc = 0;
          mode = "2560x1440";
          position = "0x0";
          rate = "144.00";
        });
      };
    };
  };
}
