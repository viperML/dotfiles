{
  description = "Fernando Ayats's system configuraion";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus/v1.3.1;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Overlays
    nur.url = github:nix-community/NUR;
  };

  outputs = inputs @ { self, nixpkgs, utils, ... }: utils.lib.mkFlake {

    inherit self inputs;

    supportedSystems = [ "x86_64-linux" ];

    channelsConfig.allowUnfree = true;
    sharedOverlays = [
      inputs.nur.overlay
    ];

    ### NIXOS Hosts

    hostDefaults.modules = [
      ./nixos/configuration.nix
      inputs.home-manager.nixosModules.home-manager
    ];

    hosts = {
      gen6.modules = [
        ./nixos/hosts/gen6.nix
      ];
      vm.modules = [
        ./nixos/hosts/vm.nix
      ];
    };

    ### Home-manager exports

    homeConfigurations = {
      "ayats@gen6" = inputs.home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        username = "ayats";
        homeDirectory = "/home/ayats";
        pkgs = self.pkgs.x86_64-linux.nixpkgs;
        configuration = {};
        extraModules = [
              ./nix/home.nix
              ./neovim/nvim.nix
              ./fish/fish.nix
              ./bat/bat.nix
              ./lsd/lsd.nix
              ./neofetch/neofetch.nix
              # ./xonsh/xonsh.nix

              # Gui
              ./nix/gui.nix

              # Personal
              ./nix/git.nix
        ];
      };
    };

  };

}
