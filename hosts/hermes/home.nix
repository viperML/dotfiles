{
  pkgs,
  packages,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  unsafeFlakePath = "/home/ayats/Documents/dotfiles";

  home.packages = [
    (inputs.self.bundlers.${pkgs.system}.addFlags {
      drv = pkgs.google-chrome;
      flags = [
        "--enable-features=WebUIDarkMode"
        "--force-dark-mode"
      ];
    })
    pkgs.vscode
    pkgs.vault
    pkgs.step-cli
    packages.self.wezterm
    pkgs.obsidian
    # pkgs.mendeley
    pkgs.scc
    packages.self.helix
  ];
}
