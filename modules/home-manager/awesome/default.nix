{
  config,
  lib,
  self,
  pkgs,
  packages,
  ...
}: {
  home.packages = [
    pkgs.nitrogen
    pkgs.lxrandr
    pkgs.flameshot
    pkgs.xorg.xwininfo
    packages.self.adw-gtk3
  ];

  xdg.configFile."awesome".source = let
    modules = builtins.removeAttrs (pkgs.callPackage ./generated.nix {}) ["override" "overrideDerivation"];
    result = pkgs.runCommandLocal "awesome-config" {} ''
      set -ex
      mkdir -p $out
      echo "awesomewm: linking self"
      for f in ${self}/modules/home-manager/awesome/*; do
        n=$(basename $f)
        ln -sfvT ${config.home.sessionVariables.FLAKE}/modules/home-manager/awesome/$n $out/$n
      done

      echo "awesomewm: linking modules"
      ${lib.concatMapStringsSep "\n" (item: "ln -sfvT ${item.src} $out/${item.pname}") (builtins.attrValues modules)}
      set +x
    '';
  in
    result.outPath;

  home.file.".Xresources".text = ''
    Xft.dpi: 96
  '';

  systemd.user.targets.tray = {
    Unit = {
      Description = "tray target";
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
    };
  };

  systemd.user.services = let
    mkService = lib.recursiveUpdate {
      Unit.After = ["graphical-session.target"];
      Install.WantedBy = ["graphical-session.target"];
    };
  in {
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

    redshift = mkService {
      Unit.Description = "Night color filter";
      Service.ExecStart = "${pkgs.redshift}/bin/redshift-gtk -c ${
        (pkgs.formats.ini {}).generate "redshift-configuration" {
          redshift = {
            location-provider = "manual";
            temp-day = 6500;
            temp-night = 3500;
            transition = 1;
            adjustment-method = "randr";
          };
          manual = {
            lat = 41;
            lon = -3;
          };
        }
      }";
    };
    xob = let
      pyenv = pkgs.python3.withPackages (p: [p.pulsectl]);
    in
      mkService {
        Unit.Description = "Visual overlay of current volume";
        Service.ExecStart = "${pyenv}/bin/python ${./xob/xob_receiver.py} | ${pkgs.xob}/bin/xob -c ${./xob/xob.cfg}";
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
