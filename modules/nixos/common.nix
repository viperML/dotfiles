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
    package = pkgs.nix;
    extraOptions = ''
      ${builtins.readFile ../nix.conf}
    '';

    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
    linkInputs = true;
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
