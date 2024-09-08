{
  config,
  pkgs,
  lib,
  ...
}: let
  run-desktop = pkgs.writers.writePerlBin "run-desktop" {
    libraries = with pkgs.perlPackages; [ConfigINI];
  } (lib.fileContents ./run-desktop.pl);
  inherit (config.services.displayManager) defaultSession;
in {
  environment.systemPackages = [run-desktop];

  services.greetd = {
    enable = true;
    settings = {
      terminal = {vt = "1";};

      default_session = let
        base = config.services.xserver.displayManager.sessionData.desktops;
      in {
        command = "${
          lib.getExe pkgs.greetd.tuigreet
        } --sessions ${base}/share/wayland-sessions:${base}/share/xsessions --remember --remember-user-session --issue";
      };

      initial_session = lib.mkIf (defaultSession != null) {
        user = config.services.xserver.displayManager.autoLogin.user;
        command = "${lib.getExe run-desktop} ${defaultSession}";
      };
    };
  };

  services.xserver.displayManager.sddm.enable = false;
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.displayManager.lightdm.enable = false;
}
