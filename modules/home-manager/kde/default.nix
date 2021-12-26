{ config, pkgs, inputs, lib, ... }:

{
  home.file.".config/multiload-ng/systray.conf".source = ../../misc/multiload-ng/systray.conf;

  home.file.".config/latte/my-layout.layout.latte".source = ./my-layout.layout.latte;

  systemd.user.services = {
    multiload-ng = {
      Unit = {
        Description = "Multiload-ng, graphical system monitor";
        After = "plasma-plasmashell.service";
      };
      Service = {
        ExecStart = "${pkgs.multiload-ng}/bin/multiload-ng-systray";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "plasma-core.target" ];
    };
    latte-dock = {
      Unit = {
        Description = "Latte dock";
        After = "plasma-plasmashell.service";
      };
      Service = {
        ExecStart = "${pkgs.latte-dock}/bin/latte-dock --replace";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "plasma-core.target" ];
    };
  };

  home.activation.kde = lib.hm.dag.entryAfter [ "writeBoundary" ] (inputs.self.lib.kde.configsToCommands
    {
      configs = {
        lattedockrc = {
          UniversalSettings.singleModeLayoutName = "my-layout";
        };
      };
    }
  );

}
