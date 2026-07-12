{ pkgs, config, ...}: let
  targets = [ config.maid.systemdTarget ];
in {
  packages = with pkgs; [
    mu
    isync
    msmtp
  ];

  systemd.tmpfiles.dynamicRules = [
    "d {{home}}/mail 0755 {{user}} {{group}} - -"
  ];

  systemd.services = {
    isync = {
      script = ''
        if [[ -d "$HOME/mail" ]]; then
          mbsync -aV
          mu index
        else
          echo ":: ~/mail doesn't exist, skipping"
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Restart = "on-abnormal";
      };
      path = [
        pkgs.isync
        pkgs.mu
      ];
      partOf = targets;
      after = targets;
      wantedBy = targets;
      # TODO: use goimapnotify
      # Every 15 minutes
      # startAt = "*-*-* *:00/15:00";
    };
  };

  # systemd.timers = {
  #   isync = {
  #     timerConfig = {
  #       Persistent = true;
  #     };
  #   };
  # };
}
