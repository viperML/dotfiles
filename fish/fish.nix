{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    fzf
    starship
  ];

  # Starship can be managed with nix but gives no advantages
    home.file.".config/starship.toml".source = ./starship.toml;

  programs.fish = {
    enable = true;
    promptInit = "starship init fish | source";
    # Standard config file when shell is interactive
    # Instead of using nix lang, in case I want to ditch Nix
    interactiveShellInit = ''
      ${builtins.readFile ./interactive.fish}
    '';
    plugins = [
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "45a9ff6d0932b0e9835cbeb60b9794ba706eef10";
          sha256 = "1kjyl4gx26q8175wcizvsm0jwhppd00rixdcr1p7gifw6s308sd5";
        };
      }
      {
        name = "done";
        src = pkgs.fetchFromGitHub {
          owner = "franciscolourenco";
          repo = "done";
          rev = "a328d3a747cb47fdbee27e04f54221ed7d639a86";
          sha256 = "1m11nsdmd82x0l3i8zqw8z3ba77nxanrycv93z25rmghw1wjyk0k";
        };
      }
      {
        name = "autopair.fish";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "autopair.fish";
          rev = "1222311994a0730e53d8e922a759eeda815fcb62";
          sha256 = "0lxfy17r087q1lhaz5rivnklb74ky448llniagkz8fy393d8k9cp";
        };
      }
      {
        name = "fzf.fish";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "176c8465b0fad2d5c30aacafff6eb5accb7e3826";
          sha256 = "16mdfyznxjhv7x561srl559misn37a35d2q9fspxa7qg1d0sc3x9";
        };
      }
      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
          sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
        };
      }
    ];
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
  };
}
