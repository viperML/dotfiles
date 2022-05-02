{
  config,
  pkgs,
  lib,
  packages,
  ...
}: {
  home.sessionVariables.SHELL = "vshell";

  home.packages = with pkgs; [
    packages.self.vshell
    packages.self.neofetch
  ];

  # programs.fish.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = false;
    config.whitelist.prefix = [
      # config.home.homeDirectory
    ];
  };
}
