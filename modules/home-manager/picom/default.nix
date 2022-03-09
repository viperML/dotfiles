{pkgs, ...}: {
  systemd.user.services = {
    picom = {
      Unit.Description = "X11 compositor";
      Service.ExecStart = "${pkgs.picom}/bin/picom --experimental-backends";
      Install.WantedBy = ["awesome-session.target"];
    };
  };

  xdg.configFile."picom/picom.conf".source = ./picom.conf;
}
