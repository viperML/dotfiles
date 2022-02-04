{ config, pkgs, inputs, ... }:

{
  system.stateVersion = "21.11";
  system.configurationRevision = (if inputs.self ? rev then inputs.self.rev else null);
  time.timeZone = "Europe/Madrid";
  documentation = {
    man.enable = true;
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  nixpkgs.config = import ../nixpkgs.conf;
  nix = {
    package = pkgs.nix; # supports flakes in nixpkgs-unstable
    extraOptions = ''
      ${builtins.readFile ../nix.conf}
    '';

    # from flake-utils-plus
    # Sets NIX_PATH to follow this flake's nix inputs
    # So legacy nix-channel is not needed
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
    linkInputs = true;

#     buildMachines = [{
#       hostName = "oci";
#       system = "aarch64-linux";
#       maxJobs = 4;
#       speedFactor = 2;
#     }];
#     distributedBuilds = true;
# 
#     binaryCachePublicKeys = [
#       "oci.ayats.org:GtvwHMXC9IuwQKfgZE8pNXGa/5K/rFahtXU3ySO6rtM="
#     ];
#     trustedBinaryCaches = [
#       "ssh://oci"
#     ];
  };

  security.sudo = {
    extraConfig = ''
      Defaults pwfeedback
      Defaults env_keep += "EDITOR PATH"
      Defaults timestamp_timeout=300
      Defaults lecture=never
      Defaults passprompt="[31msudo: password for %p@%h, running as %U:[0m "
    '';
  };
}
