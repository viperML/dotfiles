{
  pkgs,
  self',
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  unsafeFlakePath = "/home/ayats/Documents/dotfiles";

  home.packages = [
    pkgs.vscode
    self'.packages.wezterm
  ];
}
