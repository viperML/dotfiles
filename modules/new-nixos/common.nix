flake-parts-args @ {
  _inputs,
  inputs,
  withSystem,
  ...
}: {
  flake.newxosModules.common = {
    config,
    pkgs,
    self,
    lib,
    ...
  }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      inputs.nh.nixosModules.default
      ./hm-shim.nix
    ];

    options = {
      inputs = lib.mkOption {
        type = with lib.types; lazyAttrsOf anything;
        default = withSystem config.nixpkgs.hostPlatform.system ({
          inputs',
          config,
          ...
        }:
          inputs' // {self = config;});
      };
    };

    config = {
      nh = {
        enable = true;
        clean.enable = true;
      };

      documentation = {
        # Whether to install documentation of packages from environment.systemPackages into the generated system path. See "Multiple-output packages" chapter in the nixpkgs manual for more info.
        enable = true;
        # Whether to install manual pages and the man command. This also includes "man" outputs.
        man.enable = true;
        # Whether to install documentation distributed in packages' /share/doc. Usually plain text and/or HTML. This also includes "doc" outputs.
        doc.enable = false;
        # Installs man and doc pages if they are enabled
        # Takes too much time and are not cached
        nixos.enable = false;
        # crap
        info.enable = false;
      };

      nix = {
        daemonCPUSchedPolicy = "idle";
        daemonIOSchedClass = "idle";
        settings = import ../../misc/nix-conf.nix // import ../../misc/nix-conf-privileged.nix;
      };

      security.sudo.extraConfig = ''
        Defaults pwfeedback
        Defaults env_keep += "EDITOR PATH"
        Defaults timestamp_timeout=300
        Defaults lecture=never
        Defaults passprompt="[31m sudo: password for %p@%h, running as %U:[0m "
      '';

      services.udev.packages = with pkgs; [
        android-udev-rules
      ];

      environment.defaultPackages = [];
      environment.systemPackages = with pkgs; [
        usbutils
        pciutils
        vim

        config.inputs.self.packages.git

        android-tools
      ];

      # environment.defaultPackages = [
      #   pkgs.xsel
      #   pkgs.pciutils
      #   pkgs.usbutils
      #   pkgs.step-cli
      #   packages.self.git
      # ];

      # home-manager = {
      #   useGlobalPkgs = true;
      #   useUserPackages = true;
      #   sharedModules = [
      #     {
      #       home.stateVersion = lib.mkForce config.system.stateVersion;
      #     }
      #   ];
      # };

      i18n = let
        defaultLocale = "en_US.UTF-8";
        es = "es_ES.UTF-8";
      in {
        inherit defaultLocale;
        extraLocaleSettings = {
          LANG = defaultLocale;
          LC_COLLATE = defaultLocale;
          LC_CTYPE = defaultLocale;
          LC_MESSAGES = defaultLocale;

          LC_ADDRESS = es;
          LC_IDENTIFICATION = es;
          LC_MEASUREMENT = es;
          LC_MONETARY = es;
          LC_NAME = es;
          LC_NUMERIC = es;
          LC_PAPER = es;
          LC_TELEPHONE = es;
          LC_TIME = es;
        };
      };

      systemd = let
        extraConfig = ''
          DefaultTimeoutStopSec=15s
        '';
      in {
        inherit extraConfig;
        user = {inherit extraConfig;};
        services."getty@tty1".enable = false;
        services."autovt@tty1".enable = false;
        services."getty@tty7".enable = false;
        services."autovt@tty7".enable = false;

        # services."nh-gc" = {
        #   script = ''
        #     ${config.viper.package.nh.default}/bin/nh clean
        #   '';
        #   startAt = "04:00";
        #   path = [config.nix.package];
        # };

        # timers."nh-gc" = {
        #   timerConfig = {
        #     Persistent = true;
        #   };
        # };

        services."ModemManager".enable = false;
        tmpfiles.rules = [
          "D /nix/var/nix/profiles/per-user/root 755 root root - -"
        ];
      };

      home-manager = {
        # useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [
          {
            home.stateVersion = lib.mkForce config.system.stateVersion;
          }
        ];
      };

      programs.ssh = {
        startAgent = true;
        agentTimeout = "8h";
        enableAskPassword = false;
      };

      fonts.fonts = [
        pkgs.roboto
        config.inputs.self.packages.iosevka
      ];

      # Avoid TOFU
      programs.ssh.knownHosts = {
        github-rsa.hostNames = ["github.com"];
        github-rsa.publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==";
        github-ed25519.hostNames = ["github.com"];
        github-ed25519.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

        gitlab-rsa.hostNames = ["gitlab.com"];
        gitlab-rsa.publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9";
        gitlab-ed25519.hostNames = ["gitlab.com"];
        gitlab-ed25519.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";

        sourcehut-rsa.hostNames = ["git.sr.ht"];
        sourcehut-rsa.publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZ+l/lvYmaeOAPeijHL8d4794Am0MOvmXPyvHTtrqvgmvCJB8pen/qkQX2S1fgl9VkMGSNxbp7NF7HmKgs5ajTGV9mB5A5zq+161lcp5+f1qmn3Dp1MWKp/AzejWXKW+dwPBd3kkudDBA1fa3uK6g1gK5nLw3qcuv/V4emX9zv3P2ZNlq9XRvBxGY2KzaCyCXVkL48RVTTJJnYbVdRuq8/jQkDRA8lHvGvKI+jqnljmZi2aIrK9OGT2gkCtfyTw2GvNDV6aZ0bEza7nDLU/I+xmByAOO79R1Uk4EYCvSc1WXDZqhiuO2sZRmVxa0pQSBDn1DB3rpvqPYW+UvKB3SOz";
        sourcehut-ed25519.hostNames = ["git.sr.ht"];
        sourcehut-ed25519.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZvRd4EtM7R+IHVMWmDkVU3VLQTSwQDSAvW0t2Tkj60";
      };
    };
  };
}
