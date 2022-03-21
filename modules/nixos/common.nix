{
  config,
  pkgs,
  inputs,
  ...
}: {
  system.stateVersion = "21.11";
  system.configurationRevision = inputs.self.rev or null;
  time.timeZone = "Europe/Madrid";

  documentation = {
    man.enable = true;
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  nix = {
    extraOptions = ''
      ${builtins.readFile ../../misc/nix.conf}
    '';
  };

  security.sudo.extraConfig = ''
    Defaults pwfeedback
    Defaults env_keep += "EDITOR PATH"
    Defaults timestamp_timeout=300
    Defaults lecture=never
    Defaults passprompt="[31msudo: password for %p@%h, running as %U:[0m "
  '';
}
