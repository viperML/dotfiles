{
  pkgs,
  inputs,
  self,
  packages,
  lib,
  config,
  ...
}:
lib.mkMerge [
  {
    system.stateVersion = "21.11";
    # system.configurationRevision = self.rev or null;
    system.nixos.versionSuffix = lib.mkForce ".${lib.substring 0 8 (self.lastModifiedDate or self.lastModified or "19700101")}.${self.shortRev or "dirty"}";
    system.nixos.revision = lib.mkForce self.rev or null;

    documentation = {
      # Whether to install documentation of packages from environment.systemPackages into the generated system path. See "Multiple-output packages" chapter in the nixpkgs manual for more info.
      enable = true;
      # Whether to install manual pages and the man command. This also includes "man" outputs.
      man.enable = true;
      # Whether to install documentation distributed in packages' /share/doc. Usually plain text and/or HTML. This also includes "doc" outputs.
      doc.enable = false;
      # Installs man and doc pages if they are enabled
      # Takes too much time and are not cached
      nixos.enable = false;
      # crap
      info.enable = false;
    };

    nix = {
      package = packages.self.nix;
      extraOptions = ''
        ${builtins.readFile "${self.outPath}/misc/nix.conf"}
      '';
    };

    security.sudo.extraConfig = ''
      Defaults pwfeedback
      Defaults env_keep += "EDITOR PATH"
      Defaults timestamp_timeout=300
      Defaults lecture=never
      Defaults passprompt="[31msudo: password for %p@%h, running as %U:[0m "
    '';

    environment.defaultPackages = [];
  }
  (lib.mkIf (lib.hasAttr "FLAKE" config.environment.variables) {
    environment.etc."gitconfig".text = ''
      [safe]
          directory = ${config.environment.variables.FLAKE}
    '';
  })
  (lib.mkIf (lib.hasAttr "home-manager" config) {
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
  })
]
