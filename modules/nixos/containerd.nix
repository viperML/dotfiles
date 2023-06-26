{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nerdctl
  ];

  virtualisation.containerd = {
    enable = true;
  };

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
}
