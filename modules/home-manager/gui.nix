{
  pkgs,
  packages,
  ...
}: {
  xdg = {
    enable = true;
    mime.enable = true;
    # configFile."fontconfig/conf.d/10-hm-fonts.conf"
  };

  # services.syncthing = {
  #   enable = true;
  # };
  # systemd.user.services."syncthingtray" = {
  #   Install.WantedBy = ["tray.target"];
  #   Service = {ExecStart = "${pkgs.syncthingtray}/bin/syncthingtray";};
  #   Unit = {
  #     Description = "syncthingtray";
  #     After = ["tray.target"];
  #   };
  # };
}
