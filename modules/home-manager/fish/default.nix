{
  config,
  pkgs,
  lib,
  packages,
  ...
}: {
  # home.sessionVariables.SHELL = lib.mkDefault "${pkgs.fish}/bin/fish";

  home.packages = [
    pkgs.fzf
    pkgs.exa
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      ${pkgs.starship}/bin/starship init fish | source
      ${packages.self.any-nix-shell}/bin/any-nix-shell fish | source

      ${builtins.readFile ./interactive.fish}
      ${builtins.readFile ./pushd-mod.fish}
    '';
    plugins = [
      # {
      #   name = "done";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "franciscolourenco";
      #     repo = "done";
      #     rev = "d6abb267bb3fb7e987a9352bc43dcdb67bac9f06";
      #     sha256 = "1h8v5jg9kkali50qq0jn0i1w68wp4c2l0fapnglnnpg0v4vv51za";
      #   };
      # }
      # {
      #   name = "autopair.fish";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "jorgebucaran";
      #     repo = "autopair.fish";
      #     rev = "1222311994a0730e53d8e922a759eeda815fcb62";
      #     sha256 = "0lxfy17r087q1lhaz5rivnklb74ky448llniagkz8fy393d8k9cp";
      #   };
      # }
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
  programs.direnv = {
    enable = true;
    nix-direnv.enable = false;
    config.whitelist.prefix = [
      config.home.homeDirectory
    ];
  };
}
