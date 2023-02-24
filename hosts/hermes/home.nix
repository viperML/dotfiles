{
  config,
  pkgs,
  packages,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  unsafeFlakePath = "/home/ayats/Documents/dotfiles";

  home.packages = [
    pkgs.firefox
    pkgs.vscode
    pkgs.vault
    pkgs.step-cli
    packages.self.wezterm
  ];
}
