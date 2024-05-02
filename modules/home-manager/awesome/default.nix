{
  config,
  lib,
  self,
  pkgs,
  packages,
  flakePath,
  ...
}: {
  home.packages = [pkgs.nitrogen pkgs.lxrandr pkgs.flameshot pkgs.xorg.xwininfo];

  xdg.configFile."awesome".source = let
    modules = builtins.removeAttrs (pkgs.callPackage ./generated.nix {}) [
      "override"
      "overrideDerivation"
    ];
    result = pkgs.runCommandLocal "awesome-config" {} ''
      set -ex
      mkdir -p $out
      echo "awesomewm: linking self"
      for f in ${self}/modules/home-manager/awesome/*; do
        n=$(basename $f)
        ln -sfvT ${flakePath}/modules/home-manager/awesome/$n $out/$n
      done

      echo "awesomewm: linking modules"
      ${lib.concatMapStringsSep "\n"
        (item: "ln -sfvT ${item.src} $out/${item.pname}")
        (builtins.attrValues modules)}
      set +x
    '';
  in
    result.outPath;

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
      Service.Type = "oneshot";
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
    # xob = let
    #   pyenv = pkgs.python3.withPackages (p: [p.pulsectl]);
    # in
    #   mkService {
    #     Unit.Description = "Visual overlay of current volume";
    #     Service.ExecStart = "${pyenv}/bin/python ${./xob/xob_receiver.py} | ${pkgs.xob}/bin/xob -c ${./xob/xob.cfg}";
    #     Unit.After = ["pipewire-pulse.service"];
    #   };
    keyboard = mkService {
      Unit.Description = "Set keyboard layout";
      Service.Type = "oneshot";
      Service.ExecStart = with pkgs;
        (writeShellScript "systemd-keyboard" ''
          set -xe
          ${lib.getExe xorg.setxkbmap} es
        '')
        .outPath;
    };

    flameshot = mkService {
      Unit.Description = "Screenshot capture";
      Service.ExecStart = lib.getExe pkgs.flameshot;
    };
  };

  xdg.configFile."flameshot/flameshot.ini".source = (pkgs.formats.ini {}).generate "flameshot-ini" {
    General = {
      buttons = "@Variant(\\0\\0\\0\\x7f\\0\\0\\0\\vQList<int>\\0\\0\\0\\0\\n\\0\\0\\0\\x2\\0\\0\\0\\x3\\0\\0\\0\\x6\\0\\0\\0\\x12\\0\\0\\0\\xf\\0\\0\\0\\b\\0\\0\\0\\t\\0\\0\\0\\x10\\0\\0\\0\\n\\0\\0\\0\\v)";
      contrastOpacity = "219";
      copyPathAfterSave = "true";
      disabledTrayIcon = "true";
      filenamePattern = "Screenshot_%Y%m%e_%H%M%S";
      savePath = "${config.home.homeDirectory}/Pictures/Screenshots";
      showHelp = "false";
      uiColor = "#ffffff";
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

  gtk = {
    enable = true;
    cursorTheme = {name = "Adwaita";};
    font = {
      name = "Roboto";
      size = 10;
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
    theme = {
      package = packages.self.adw-gtk3;
      name = "adw-gtk3-dark";
    };
  };
}
