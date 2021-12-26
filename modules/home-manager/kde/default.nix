{ config, pkgs, inputs, lib, ... }:

{
  home.packages = with pkgs; [
    latte-dock
  ];

  home.file.".config/multiload-ng/systray.conf".source = ../../misc/multiload-ng/systray.conf;

  home.file.".config/latte/original/my-layout.layout.latte".source = ./my-layout.layout.latte;

  # systemd.user.services = {
    # multiload-ng = {
    #   Unit = {
    #     Description = "Multiload-ng, graphical system monitor";
    #     After = "plasma-plasmashell.service";
    #   };
    #   Service = {
    #     ExecStart = "${pkgs.multiload-ng}/bin/multiload-ng-systray";
    #     Restart = "on-failure";
    #   };
    #   Install.WantedBy = [ "plasma-core.target" ];
    # };
    # latte-dock = {
    #   Unit = {
    #     Description = "Latte dock";
    #     After = "plasma-plasmashell.service";
    #   };
    #   Service = {
    #     ExecStart = "${pkgs.latte-dock}/bin/latte-dock --replace";
    #     Restart = "on-failure";
    #   };
    #   Install.WantedBy = [ "plasma-core.target" ];
    # };
  # };

  # home.activation.kde = lib.hm.dag.entryAfter [ "writeBoundary" ] (inputs.self.lib.kde.configsToCommands
  #   {
  #     configs = {
  #       lattedockrc = {
  #         UniversalSettings.singleModeLayoutName = "my-layout";
  #       };
  #     };
  #   }
  # );

  home.file.".config/autostart/start-latte.sh.desktop".text = ''
    [Desktop Entry]
    Exec=/home/ayats/.config/autostart/start-latte.sh
    Icon=dialog-scripts
    Name=start-latte.sh
    Path=
    Type=Application
    X-KDE-AutostartScript=true
  '';

  home.file.".config/autostart/start-latte.sh" = {
    executable = true;
    text = ''
    #!${pkgs.bash}/bin/bash
    if [[ -f $HOME/.config/latte/my-layout.layout.latte ]]; then
        ${pkgs.latte-dock}/bin/latte-dock --layout my-layout
    else
        ${pkgs.latte-dock}/bin/latte-dock --import-layout $HOME/.config/latte/original/my-layout.layout.latte
    fi
    '';
  };

}
