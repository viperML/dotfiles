{
  pkgs,
  inputs,
  self,
  packages,
  lib,
  config,
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs self packages;};
    sharedModules = [
      {
        home.stateVersion = lib.mkForce config.system.stateVersion;
      }
    ];
  };

  system.stateVersion = "21.11";
  system.configurationRevision = self.rev or null;

  documentation = {
    man.enable = true;
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  nix = {
    # package = packages.nix-dram.nix-dram;
    extraOptions = ''
      ${builtins.readFile "${self.outPath}/misc/nix.conf"}
    '';
  };

  security.sudo.extraConfig = ''
    Defaults pwfeedback
    Defaults env_keep += "EDITOR PATH"
    Defaults timestamp_timeout=300
    Defaults lecture=never
    Defaults passprompt="^[[31msudo: password for %p@%h, running as %U:^[[0m "
  '';

  environment.defaultPackages = [];
}
