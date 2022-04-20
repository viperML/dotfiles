{
  description = "My awesome dotfiles";

  outputs = inputs: let
    inherit (inputs) self nixpkgs;
    supportedSystems = ["x86_64-linux"];
    config = import ./misc/nixpkgs.nix;
    inherit (builtins) mapAttrs readDir;
    inherit (nixpkgs.lib) attrValues genAttrs;
    inherit (self.lib) exportModulesDir;
  in {
    lib = import ./lib nixpkgs.lib;
    nixosModules = exportModulesDir ./modules/nixos;
    homeModules = exportModulesDir ./modules/home-manager;
    specialisations = import ./specialisations self;
    nixosConfigurations = mapAttrs (name: _: import (./hosts + "/${name}") {inherit self inputs;}) (readDir ./hosts);

    legacyPackages = genAttrs supportedSystems (system: inputs.nixpkgs-unfree.legacyPackages.${system});

    packages = genAttrs supportedSystems (
      system:
        import ./packages inputs.nixpkgs-unfree.legacyPackages.${system}
        # Packages to build and cache in CI
        // {
          nix-dram = inputs.nix-dram.packages.${system}.nix-dram.overrideAttrs (prev: {
            postInstallCheck =
              (prev.postInstallCheck or "")
              + ''
                rm $out/bin/nix-channel
              '';
          });
          inherit (inputs.nh.packages.${system}) nh;
        }
    );

    devShells = genAttrs supportedSystems (system:
      with self.legacyPackages.${system}; {
        default = let
          pyEnv = python3.withPackages (p:
            with p; [
              grip
              black
              flake8
              #
              url-normalize
            ]);
        in
          mkShell {
            name = "dotfiles-basic-shell";
            packages = [
              pyEnv
            ];
            shellHook = ''
              ln -sf $PWD/bin/pre-commit.sh .git/hooks/pre-commit
              mkdir -p .venv
              # Vscode is dumb
              ln -sf ${pyEnv}/bin .venv/
            '';
            DRY = "1";
          };
      });
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    # https://github.com/NixOS/nixpkgs/pull/168554
    # https://nixpk.gs/pr-tracker.html?pr=168554
    nixpkgs-luks.url = "github:helsinki-systems/nixpkgs/feat/systemd-stage-1-luks";

    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs.emacs-overlay.follows = "emacs-overlay";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    alejandra = {
      url = "github:kamadorueda/alejandra";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flakeUtils.follows = "flake-utils";
      inputs.flakeCompat.follows = "flake-compat";
    };
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    nixos-flakes = {
      url = "github:viperML/nixos-flakes";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.flake-compat.follows = "flake-compat";
    };
    nix-dram = {
      url = "github:dramforever/nix-dram";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
    };
    nixpkgs-unfree = {
      url = "github:numtide/nixpkgs-unfree";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
