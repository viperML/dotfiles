{
  description = "My NixOS system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: {
    # Change myHost to your hostname
    nixosConfigurations.myHost = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      pkgs = self.legacyPackages."x86_64-linux";
      specialArgs = {
        inherit self inputs;
      };
      modules = [
        ./configuration.nix
      ];
    };

    # Global config of nixpkgs
    # Don't configure nixpkgs (overlays, config) inside configuration.nix
    # We do it here and propagate it to the config
    legacyPackages."x86_64-linux" = import nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
      overlays = [
        # ./overlay.nix
      ];
    };
    # This way, you can run packages that have been patched by your overlays
    # Or configured packages (allowUnfree)
    # by using `nix run .#<my-package>`
  };

  /*
   Some nix lang refresher...
   { inherit something; }
   is the same as
   { something = something; }
   
    inputs@{...} puts all the arguments into the inputs.
    For example, we could access inputs.self, inputs.nixpkgs, inputs.whatever-you-add
    self, nixpkgs are inside the argset, so you can also access them without inputs.
   */
}
