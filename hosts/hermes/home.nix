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
    packages.self.wezterm
    pkgs.obsidian
    packages.self.helix
    (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.rust-rover [
      "github-copilot"
      "ideavim"
    ])
    pkgs.d-spy
  ];
}
