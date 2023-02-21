{
  config,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = {
    FLAKE = "/home/ayats/Documents/dotfiles";
  };

  home.packages = [
    config.packages.self.nil
    pkgs.alejandra
    pkgs.firefox
    pkgs.vscode
    config.packages.self.fish
  ];
}
