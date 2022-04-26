{
  self,
  inputs,
}: let
  system = "x86_64-linux";

  nixpkgs-src = self.lib.patch-nixpkgs {
    nixpkgs = inputs.nixpkgs-master;
    patches = [
      rec {
        name = "168554";
        url = "https://github.com/NixOS/nixpkgs/pull/${PR}.patch";
        sha256 = "sha256-t+2LgUdbKbpxtT1wax2PCmzwGFQLrHJOs1QbskNVqV4=";
        exclude = ["*/all-tests.nix"];
      }
      rec {
        name = "168269";
        url = "https://github.com/NixOS/nixpkgs/pull/${PR}.patch";
        sha256 = "sha256-ptJ6P7qqN78FeS/v1qST8Ut99WyI4tRCnPv+aO/dAOQ=";
        # exclude = ["*/all-tests.nix"];
      }
    ];
    pkgs = self.legacyPackages.${system};
  };
  nixosSystem = args: import "${nixpkgs-src}/nixos/lib/eval-config.nix" args;
  modulesPath = "${nixpkgs-src}/nixos/modules";
in
  nixosSystem rec {
    inherit system;
    pkgs = self.legacyPackages.${system};
    specialArgs = {inherit self inputs;};
    modules = with self.nixosModules; [
      ./configuration.nix
      (modulesPath + "/profiles/qemu-guest.nix")
      (modulesPath + "/profiles/minimal.nix")
      inputs.nixos-flakes.nixosModules.channels-to-flakes
    ];
  }
