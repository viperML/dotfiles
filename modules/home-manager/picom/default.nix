{
  packages,
  config,
  ...
}: {
  systemd.user.services = {
    picom = {
      Unit.Description = "X11 compositor";
      Service.ExecStart = "${packages.self.picom}/bin/picom --experimental-backends";
      Install.WantedBy = ["awesome-session.target"];
    };
  };

  xdg.configFile."picom/picom.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.sessionVariables.FLAKE}/modules/home-manager/picom/picom.conf";
}
