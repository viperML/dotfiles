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

      ${builtins.readFile ./interactive.fish}
      ${builtins.readFile ./pushd-mod.fish}
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
      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "b3dd471bcc885b597c3922e4de836e06415e52dd";
          sha256 = "13wdsvpazivlxk921ccqbk7gl6ya2md8f45rckbn8rn119ckf7fy";
        };
      }
    ];
  };

  home.sessionVariables.MANPAGER = "sh -c 'col -bx | bat --paging=always -l man -p'";
  xdg.configFile."bat/config".source = ./bat-config;
  xdg.configFile."starship.toml".source = ./starship.toml;
}
