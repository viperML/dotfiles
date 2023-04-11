{
  pkgs,
  packages,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  unsafeFlakePath = "/home/ayats/Documents/dotfiles";

  home.packages = [
    # pkgs.google-chrome
    (inputs.self.libFor.${pkgs.system}.addFlags pkgs.google-chrome [
      "--enable-features=WebUIDarkMode"
      "--force-dark-mode"
    ])
    pkgs.vscode
    pkgs.vault
    pkgs.step-cli
    packages.self.wezterm
    pkgs.obsidian
    pkgs.mendeley
  ];
}
