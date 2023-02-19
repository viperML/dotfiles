flake-parts-args @ {_inputs, ...}: {
  flake.newxosModules.common = {
    config,
    pkgs,
    self,
    lib,
    ...
  }: {
    options = {
      viper.packages = lib.mkOption {
        type = with lib.types; attrsOf (lazyAttrsOf package);
        default = flake-parts-args.config.flake.lib.mkPackages flake-parts-args._inputs config.nixpkgs.hostPlatform.system;
      };
    };

    config = {
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
        settings = import ../../misc/nix-conf.nix // import ../../misc/nix-conf-privileged.nix;
      };

      security.sudo.extraConfig = ''
        Defaults pwfeedback
        Defaults env_keep += "EDITOR PATH"
        Defaults timestamp_timeout=300
        Defaults lecture=never
        Defaults passprompt="[31m sudo: password for %p@%h, running as %U:[0m "
      '';

      environment.defaultPackages = [];
      environment.systemPackages = with pkgs; [
        usbutils
        pciutils
        vim

        config.viper.packages.self.git
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
    };
  };
}
