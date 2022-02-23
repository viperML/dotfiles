{
  description = "My NixOS system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.myHost = nixpkgs.lib.nixosSystem rec {
      inherit system;
      pkgs = self.legacyPackages.${system};
      specialArgs = {
        inherit self inputs;
      };
      modules = [
        (import ./configuration.nix) # readme
      ];
    };

    # Global config of nixpkgs
    legacyPackages.${system} = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
      overlays = [
        # My awesome overlay I got from the internet
      ];
    };
  };

  /*
   Some nix lang refresher...
   { inherit somehting; } === { something = something; }
   
   We can use "let in", to get local variables, that don't get exported
   (functional language without side effects)
   
   outputs is a function, that takes many arguments and puts then into inputs.my-input
   nixpkgs === inputs.nixpkgs (because we also have nixpkgs in the args)
   */
}
