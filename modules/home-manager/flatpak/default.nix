{
  config,
  pkgs,
  lib,
  ...
}: let
  autoinstall = pkgs.substituteAll {
    src = ./flatpak-autoinstall.py;
    python3 = pkgs.python3.withPackages (pP: with pP; [toml]);
  };
  autoinstallChecked =
    pkgs.runCommandNoCC "flatpak-autoinstall" {
      nativeBuildInputs = [
        (pkgs.python3.withPackages (pP: with pP; [mypy types-toml]))
        pkgs.makeWrapper
      ];
    } ''
      mypy \
        --no-implicit-optional \
        --disallow-untyped-calls \
        --disallow-untyped-defs \
        ${autoinstall}
      mkdir -p $out
      install -Dm755 ${autoinstall} $out/main
      wrapProgram $out/main \
        --prefix PATH : ${lib.makeBinPath (with pkgs; [flatpak])}
    '';
  chromiumFlags = [
    "--enable-features=VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization"
    "--use-gl=desktop"
    "--ignore-gpu-blocklist"
    # "--enable-oop-rasterization"
    # "--enable-raw-draw"
    # "--enable-gpu-rasterization"
    # "--use-vulkan"
    # "--disable-reading-from-canvas"
    # "--disable-sync-preferences"
    # "--enable-features=WebUIDarkMode"
    # "--force-dark-mode"
  ];
  flags-conf = pkgs.writeText "flags.conf" (lib.concatStringsSep "\n" chromiumFlags);
in {
  xdg.dataFile."flatpak-required.toml" = {
    source = ./required.toml;
    onChange = ''
      systemctl --user restart flatpak-autoinstall.service
    '';
  };

  systemd.user = {
    services = {
      flatpak-autoinstall = {
        Unit.Description = "Install and remove flatpaks to match the required packages";
        Service.ExecStart = "${autoinstallChecked}/main ${config.xdg.dataHome}/flatpak-required.toml";
        Service.ExecStartPre = "${pkgs.coreutils}/bin/sleep 10";
        Install.WantedBy = ["default.target"];
        Unit.After = ["flatpak-session-helper.service"];
      };
      flatpak-update = {
        Unit.Description = "Update all flatpaks";
        Service.ExecStart =
          (pkgs.writeShellScript "update-flatpak" ''
            ${pkgs.flatpak}/bin/flatpak update --user --noninteractive
            ${pkgs.flatpak}/bin/flatpak uninstall --user --unused --noninteractive
          '')
          .outPath;
      };
    };
    timers = {
      flatpak-update = {
        Unit.Description = "Update all flatpaks on a schedule";
        Unit.PartOf = ["update-flatpak.service"];
        Timer.OnCalendar = ["weekly"];
        Timer.Persistent = true;
        Install.WantedBy = ["timers.target"];
      };
    };
    tmpfiles.rules = with config; [
      "L+ ${xdg.dataHome}/fonts - - - - /etc/profiles/per-user/${home.username}/share/fonts"
      "L+ ${home.homeDirectory}/.var/app/com.google.Chrome/config/chrome-flags.conf - - - - ${flags-conf}"
    ];
  };
}
