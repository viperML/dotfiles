{ pkgs
, packages
, ...
}: {
  nixpkgs.config.allowUnfree = true;

  unsafeFlakePath = "/home/ayats/Documents/dotfiles";

  home.packages = [
    pkgs.vscode
    pkgs.vault
    packages.self.wezterm
    # pkgs.obsidian
    pkgs.d-spy
  ];
}
