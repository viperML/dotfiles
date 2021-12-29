{ config, pkgs, ... }:
{
  system.stateVersion = "21.11";
  system.configurationRevision = (if inputs.self ? rev then inputs.self.rev else null);
  time.timeZone = "Europe/Madrid";

  nixpkgs.config.allowUnfree = true;

  security.sudo.wheelNeedsPassword = false;

  # (from flake-utils-plus)
  # Set the NIX_PATH from the flake inputs
  # So nix-channel is not needed anymore
  nix = {
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
    linkInputs = true;
  };
}
