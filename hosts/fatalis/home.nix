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
    # pkgs.obsidian
    # pkgs.synology-drive-client
  ];
}
