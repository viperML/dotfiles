{
  pkgs,
  self',
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  unsafeFlakePath = "/home/ayats/Documents/dotfiles";

  home.packages = [
    self'.packages.vscode
    pkgs.vault
    self'.packages.wezterm
    pkgs.sbctl
  ];
}
