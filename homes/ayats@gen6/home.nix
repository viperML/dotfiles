{
  packages,
  pkgs,
  lib,
  self,
  config,
  ...
}: let
  env = {
    FLAKE = "/mnt/c/Users/ayats/Documents/dotfiles";
    EDITOR = "nvim";
    SHELL = "fish";
  };
in {
  home.sessionVariables = env;

  home.packages = [
    packages.home-manager.default
    pkgs.step-cli
    packages.self.neofetch
    packages.self.vshell
    packages.self.neovim
  ];

  xdg.configFile."nix/nix.conf".text = lib.mkAfter ''
    ${lib.fileContents ./nix.conf}
  '';

  xdg.configFile."nix/rc".text = ''
    eval "$(${lib.getExe pkgs.direnv} hook bash)"
    ${lib.concatStringsSep "\n" (__attrValues (__mapAttrs (n: v: "export ${n}=${v}") config.home.sessionVariables))}
  '';
}