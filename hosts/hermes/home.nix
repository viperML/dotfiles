{ pkgs
, self'
, ...
}: {
  nixpkgs.config.allowUnfree = true;

  unsafeFlakePath = "/home/ayats/Documents/dotfiles";

  home.packages = [
    pkgs.vscode
    pkgs.vault
    self'.packages.wezterm
    pkgs.sbctl
  ];
}
