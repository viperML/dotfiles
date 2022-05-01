{
  config,
  pkgs,
  lib,
  packages,
  ...
}: {
  home.sessionVariables.SHELL = "fish";

  home.packages = with pkgs; [
    fzf
    exa
    bat
    packages.self.any-nix-shell
    packages.self.neofetch
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = false;
    config.whitelist.prefix = [
      # config.home.homeDirectory
    ];
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      ${pkgs.starship}/bin/starship init fish | source
      ${packages.self.any-nix-shell}/bin/any-nix-shell fish | source

      ${lib.fileContents ./interactive.fish}
      ${lib.fileContents ./pushd-mod.fish}
    '';
    plugins = [
      {
        name = "fzf.fish";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "8d877a973c1fa22f8bedd8b4cf70243ddcd983ac";
          sha256 = "1njxn9ldby5lsd4rvgxqs4qgfsw7xchbf6v971ls06cyxrnzflf0";
        };
      }
    ];
  };

  home.sessionVariables.MANPAGER = "sh -c 'col -bx | bat --paging=always -l man -p'";
  xdg.configFile."bat/config".source = ./bat-config;
  xdg.configFile."starship.toml".source = ./starship.toml;
}
