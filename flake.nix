{
  description = "Fernando Ayats's system configuraion";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Overlays
    nur.url = github:nix-community/NUR;
  };

  outputs = inputs @ { self,
                       nixpkgs,
                       utils,
                       home-manager,
                       nur
                      }: utils.lib.mkFlake {

    inherit self inputs;

    channelsConfig.allowUnfree = true;
    sharedOverlays = [
      nur.overlay
    ];

    hostDefaults.modules = [
      ./nixos/configuration.nix
      home-manager.nixosModules.home-manager
    ];

    hosts.gen6.modules = [
      ./nixos/hosts/gen6.nix
    ];



  };


}
