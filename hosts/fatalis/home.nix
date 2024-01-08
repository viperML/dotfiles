{
  pkgs,
  packages,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  unsafeFlakePath = "/home/ayats/dotfiles";

  home.packages = [
    pkgs.vscode
    packages.self.wezterm
    pkgs.firefox
    # pkgs.obsidian
  ];
}
