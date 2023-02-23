{
  config,
  pkgs,
  packages,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = {
    FLAKE = "/home/ayats/Documents/dotfiles";
  };

  home.packages = [
    pkgs.firefox
    pkgs.vscode
    pkgs.vault
  ];
}
