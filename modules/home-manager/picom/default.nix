{packages, ...}: {
  systemd.user.services = {
    picom = {
      Unit.Description = "X11 compositor";
      Service.ExecStart = "${packages.self.picom}/bin/picom --experimental-backends";
      Install.WantedBy = ["awesome-session.target"];
    };
  };

  xdg.configFile."picom/picom.conf" = {
    source = ./picom.conf;
    onChange = ''
      systemctl --user is-active picom.service --quiet && systemctl --user restart picom.service
    '';
  };
}
