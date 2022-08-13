{
  packages,
  config,
  ...
}: let
  pkg = packages.self.picom;
in {
  systemd.user.services = {
    picom = {
      Unit.Description = "X11 compositor";
      Service.ExecStart = "${pkg}/bin/picom --experimental-backends";
      Install.WantedBy = ["awesome-session.target"];
    };
  };

  home.packages = [pkg];

  xdg.configFile."picom/picom.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.sessionVariables.FLAKE}/modules/home-manager/picom/picom.conf";
}
