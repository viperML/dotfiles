{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    fzf
  ];

  home.file.".config/starship.toml".text = ''
    ${builtins.readFile ../starship/starship.toml}
    [custom.nix]
    command = "${pkgs.any-nix-shell}/bin/nix-shell-info"
    when = "${pkgs.any-nix-shell}/bin/nix-shell-info"
    symbol = ""
    style = "bold cyan"
    format = "[$symbol]($style) [$output]($style)"
  '';

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      ${pkgs.starship}/bin/starship init fish | source
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish | source

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
          rev = "d6abb267bb3fb7e987a9352bc43dcdb67bac9f06";
          sha256 = "1h8v5jg9kkali50qq0jn0i1w68wp4c2l0fapnglnnpg0v4vv51za";
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
          rev = "9f7d5b8df62f712f0d2667b67a4c88ea1ec609d1";
          sha256 = "0f67qlnca4l7ik9wxamwn152n0sin559dkc4apqnlbil4fsswxvz";
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
      {
        name = "fish-abbreviation-tips";
        src = pkgs.fetchFromGitHub {
          owner = "Gazorby";
          repo = "fish-abbreviation-tips";
          rev = "75f7f66ca092d53197c1a97c7d8e93b1402fdc15";
          sha256 = "0imwsq0hs8m1msjxkg4gvnclh7q1sz5zkqb16m859v1aih02k3xs";
        };
      }
    ];
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = false;
    config.whitelist.prefix = [
      "/home"
    ];

  };
}
