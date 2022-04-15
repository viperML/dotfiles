{
  config,
  pkgs,
  packages,
  ...
}: {
  home.sessionVariables.EDITOR = "nvim";

  home.packages = [
    packages.self.neovim
  ];
}
