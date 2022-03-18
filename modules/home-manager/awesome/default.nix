args @ {
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
      adw-gtk3
      rose-pine-gtk-theme
      # Required by keybinds
      
      pulseaudio
      ;

    inherit
      (pkgs.xorg)
      # Required by bling
      
      xwininfo
      ;
  };

  systemd.user.tmpfiles.rules =
    map (f: "L+ ${finalPath}/${f} - - - - ${selfPath}/${f}") [
      "rc.lua"
      "rc"
      "ui"
      "helpers.lua"
      "theme"
      "res"
    ]
    ++ attrValues (mapAttrs (name: value: "L+ ${finalPath}/${name} - - - - ${value.outPath}") modules);

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
    caffeine = mkService {
      Unit.Description = "Caffeine applet";
      Service.ExecStart = "${pkgs.caffeine-ng}/bin/caffeine";
    };
    mailspring = mkService {
      Unit.Description = "Mail client";
      Service.ExecStart = "${pkgs.mailspring}/bin/mailspring --background";
      Service.Restart = "on-failure";
    };
    autorandr-boot = mkService {
      Unit.Description = "Load autorandr on boot";
      Service.ExecStart = "${pkgs.autorandr}/bin/autorandr --change";
    };
    polkit-agent = mkService {
      Unit.Description = "GNOME polkit agent";
      Service.ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    };
    xsettingsd = mkService {
      Unit.Description = "Cross desktop configuration daemon";
      Service.ExecStart = "${pkgs.xsettingsd}/bin/xsettingsd";
      Unit.After = ["xsettingsd-switch.service"];
    };
    xsettingsd-switch = let
      xsettingsConfig = import ./xsettings.nix {inherit args;};
      xsettingsd-switch-script = pkgs.writeShellScript "xsettings-switch" ''
        export PATH="${pkgs.coreutils-full}/bin:${pkgs.systemd}/bin"
        if (( $(date +"%-H%M") < 1800 )) && (( $(date +"%-H%M") > 0500 )); then
          ln -sf ${xsettingsConfig.light} ${config.xdg.configHome}/xsettingsd/xsettingsd.conf
        else
          ln -sf ${xsettingsConfig.dark} ${config.xdg.configHome}/xsettingsd/xsettingsd.conf
        fi
        systemctl --user restart xsettingsd.service
      '';
    in
      mkService {
        Unit.Description = "Reload the xsettingsd with new configuration";
        Service.ExecStart = xsettingsd-switch-script.outPath;
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

  systemd.user.timers = {
    xsettingsd-switch = {
      Unit.Description = "Apply xsettings on schedule";
      Unit.PartOf = ["xsettingsd-switch.service"];
      Timer.OnCalendar = ["*-*-* 18:01:00" "*-*-* 05:01:00"];
      Install.WantedBy = ["timers.target"];
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
