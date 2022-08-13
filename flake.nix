{
  description = "My awesome dotfiles";

  nixConfig = {
    extra-substituters = ["https://viperml.cachix.org"];
    extra-trusted-public-keys = ["viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8="];
  };

  outputs = inputs: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    inherit (inputs) self nixpkgs;
    inherit (nixpkgs) lib;
    inherit (builtins) mapAttrs readDir elem;
    inherit (nixpkgs.lib) attrValues genAttrs recursiveUpdate getName;
    inherit (self.lib) exportModulesDir;

    genSystems = genAttrs supportedSystems;
    pkgsFor = builtins.listToAttrs (map (system:
      lib.nameValuePair system (import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      }))
    supportedSystems);
  in {
    nixosModules = builtins.removeAttrs (exportModulesDir ./modules/nixos) ["users"];
    homeModules = exportModulesDir ./modules/home-manager;
    specialisations = import ./specialisations inputs;
    nixosConfigurations = mapAttrs (name: _: import ./hosts/${name} inputs) (readDir ./hosts);
    homeConfigurations = mapAttrs (name: _: import ./homes/${name} inputs) (readDir ./homes);

    lib =
      (import ./lib {
        inherit (nixpkgs) lib;
        inherit inputs;
      })
      // genSystems (
        system:
          import ./lib/perSystem.nix pkgsFor.${system}
      );

    legacyPackages = pkgsFor;

    packages =
      recursiveUpdate (genSystems (
        system:
          import ./packages pkgsFor.${system} inputs
          # Packages to build and cache in CI
          // {
            nh = inputs.nh.packages.${system}.default;
            inherit (inputs.deploy-rs.packages.${system}) deploy-rs;
            inherit (inputs.nil.packages.${system}) nil;

            # Target for the rest of the system
            nix = inputs.nix.packages.${system}.nix;

            nix-lto = inputs.nix.packages.${system}.nix.overrideAttrs (prev: {
              __nocachix = true;
              configureFlags =
                prev.configureFlags
                ++ [
                  "--enable-lto"
                ];
            });

            nix-static = inputs.nix.packages.${system}.nix-static.overrideAttrs (prev: {
              __nocachix = true;
            });

            zzz_devShell = self.devShells.${system}.default.inputDerivation;

            update-nix-fetchgit = pkgsFor.${system}.update-nix-fetchgit.overrideAttrs (prev: {
              doCheck = false;
            });

            iosevka = inputs.iosevka.packages.${system}.default;
          }
      )) {
        "x86_64-linux" = {
          zzz_homeConfigurations-ayats-activationPackage = self.homeConfigurations.ayats.activationPackage;
        };
      };

    devShells = genSystems (system: {
      default = import ./shell.nix (pkgsFor.${system} // self.packages.${system});
    });

    templates = mapAttrs (name: _: {
      inherit (import ./templ/${name}/flake.nix) description;
      path = ./templ/${name};
    }) (readDir ./templ);
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nix = {
      url = "github:NixOS/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-common = {
      url = "github:viperML/nix-common";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-wsl = {
      url = "github:viperML/home-manager-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    iosevka = {
      url = "github:viperML/iosevka";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-autobahn = {
      url = "github:Lassulus/nix-autobahn";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # emacs-overlay = {
    #   url = "github:nix-community/emacs-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # nix-doom-emacs = {
    #   url = "github:nix-community/nix-doom-emacs";
    #   inputs.emacs-overlay.follows = "emacs-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nix-std.url = "github:chessai/nix-std";
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      # url = "/home/ayats/Documents/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
    };
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
