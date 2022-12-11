{
  pkgs,
  flakePath,
  lib,
  ...
}: let
  eww = pkgs.eww-wayland;
  configPath = "${flakePath}/modules/home-manager/eww";
in {
  home.packages = [eww];

  systemd.user.services = let
    mkEww = x: {
      Service.ExecStart = "${eww}/bin/eww open ${x} --no-daemonize --config ${configPath}";
      Unit.After = ["eww-daemon.service"];
      Install.WantedBy = ["graphical-session.target"];
      Service.Restart = "always";
    };
  in {
    eww-daemon = {
      Service.ExecStart = "${eww}/bin/eww daemon --no-daemonize --config ${configPath}";
      Service.Restart = "on-failure";
      Install.WantedBy = ["graphical-session.target"];
      Service.Environment = "PATH${lib.makeBinPath (with pkgs; [coreutils-full])}";
    };

    eww-bar = mkEww "bar";
  };
}
