{ config, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = false;
    powerManagement.enable = true;
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    gsp.enable = true;
  };

  boot = {
    kernelParams = [
      "nvidia.NVreg_UsePageAttributeTable=1"
    ];

    blacklistedKernelModules = [
      "amdgpu"
      "nouveau"
      "ee1004"
    ];

    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
    ];
  };

  # https://discourse.nixos.org/t/suspend-resume-cycling-on-system-resume/32322/11
  systemd = {
    services."gnome-suspend" = {
      description = "suspend gnome shell";
      before = [
        "systemd-suspend.service"
        "systemd-hibernate.service"
        "nvidia-suspend.service"
        "nvidia-hibernate.service"
      ];
      wantedBy = [
        "systemd-suspend.service"
        "systemd-hibernate.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''${pkgs.procps}/bin/pkill -f -STOP ${pkgs.gnome-shell}/bin/gnome-shell'';
      };
    };
    services."gnome-resume" = {
      description = "resume gnome shell";
      after = [
        "systemd-suspend.service"
        "systemd-hibernate.service"
        "nvidia-resume.service"
      ];
      wantedBy = [
        "systemd-suspend.service"
        "systemd-hibernate.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''${pkgs.procps}/bin/pkill -f -CONT ${pkgs.gnome-shell}/bin/gnome-shell'';
      };
    };
  };

  programs.steam = {
    enable = true;
  };

  programs.gamemode = {
    enable = true;
  };
}
