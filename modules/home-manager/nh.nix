{
  pkgs,
  inputs,
  ...
}: {
  systemd.user = {
    services.nh-gcr-clean = {
      Unit.Description = "Remove gc roots from home dir";
      Service.Type = "oneshot";
      Service.ExecStart =
        (pkgs.writeShellScript "nh-gcr-clean" ''
          ${inputs.nh.packages.${pkgs.system}.nh}/bin/nh gcr-clean --age 7d
        '')
        .outPath;
    };
    timers.nh-gcr-clean = {
      Unit.Description = "Remove gc roots daily";
      Unit.PartOf = ["nh-gcr-clean.service.service"];
      Timer.OnCalendar = ["daily"];
      Timer.Persistent = true;
      Install.WantedBy = ["timers.target"];
    };
  };
}
