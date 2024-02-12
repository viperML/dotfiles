{
  pkgs,
  packages,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  unsafeFlakePath = "/home/ayats/Documents/dotfiles";

  home.packages = [
    pkgs.vscode
    packages.self.wezterm

    pkgs.process-compose
    pkgs.just
  ];
}
