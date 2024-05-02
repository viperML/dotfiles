{
  pkgs,
  config,
  lib,
  ...
}: let
  groupName = "containerd";
  nerdctl = pkgs.nerdctl.override {makeWrapper = pkgs.makeBinaryWrapper;};
in {
  environment.systemPackages = [nerdctl];

  virtualisation.containerd = {enable = true;};

  systemd = {
    timers."containerd-prune" = {
      wantedBy = ["timers.target"];
      partOf = ["containerd-prune.service"];
      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
      };
    };
    services."containerd-prune" = {
      serviceConfig.Type = "oneshot";
      script = ''
        ${pkgs.nerdctl}/bin/nerdctl system prune --all --force
      '';
      requires = ["containerd.service"];
    };
  };

  users.groups.${groupName} = {members = config.users.groups.wheel.members;};

  security.wrappers = {
    "nerdctl" = {
      setuid = true;
      owner = "root";
      group = groupName;
      permissions = "u+rx,g+rx";
      source = lib.getExe nerdctl;
    };
  };
}
