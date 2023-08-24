{
  pkgs,
  packages,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  unsafeFlakePath = "/home/ayats/Documents/dotfiles";

  home.packages = [
    pkgs.vscode
    pkgs.vault
    pkgs.step-cli
    packages.self.wezterm
    pkgs.obsidian
    # pkgs.mendeley
    pkgs.scc
    packages.self.helix
    pkgs.mosh
  ];
}
