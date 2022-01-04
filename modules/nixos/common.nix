{ config, pkgs, inputs, ... }:

{
  system.stateVersion = "21.11";
  system.configurationRevision = (if inputs.self ? rev then inputs.self.rev else null);
  time.timeZone = "Europe/Madrid";


  security.sudo.wheelNeedsPassword = false;

  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "${builtins.readFile ../nix.conf}";
    # from flake-utils-plus
    # Sets NIX_PATH to follow this flake's nix inputs
    # So legacy nix-channel is not needed
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
    linkInputs = true;
  };
  environment.etc."nixpkgs/config.nix".text = "${builtins.readFile ../nixpkgs.conf}";
}
