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
    packages.self.nil
    pkgs.alejandra
    pkgs.firefox
    pkgs.vscode
    packages.self.fish
    packages.self.neofetch
    pkgs.vault
  ];
}
