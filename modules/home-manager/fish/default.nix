{ config
, pkgs
, lib
, ...
}:
{
  # home.sessionVariables.SHELL = lib.mkDefault "${pkgs.fish}/bin/fish";

  home.packages =
    with pkgs;
    [
      fzf
    ];

  home.file.".config/starship.toml".text = ''
    ${builtins.readFile ../../../misc/starship/starship.toml}

    [custom.nix]
    command = "${pkgs.any-nix-shell}/bin/nix-shell-info"
    when = "${pkgs.any-nix-shell}/bin/nix-shell-info"
    symbol = ""
    style = "bold cyan"
    format = """>>= [$symbol]($style) [$output]($style)
    """
  '';

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      ${pkgs.starship}/bin/starship init fish | source
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish | source

      ${builtins.readFile ./interactive.fish}
      ${builtins.readFile ./pushd-mod.fish}
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
          rev = "22dd68487b2e53ee6f2bddef69cfd9c0c643bb95";
          sha256 = "0973wy17h4ic2g5pk6f2mqzzsrn6pka9n8m2nn9fww3b2xnib9ms";
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
          rev = "d29a52375a0826ed86b0710f58b2495a73d3aff3";
          sha256 = "0s6zcxlhfys545lnfg626ilk1jqgak9xpijy3jxs9z12w2c4d3gk";
        };
      }
    ];
  };

  programs.direnv = {
    enable = true;
    # enableFishIntegration = true;
    nix-direnv.enable = false;
    config.whitelist.prefix = [
      "/home"
    ];
  };
}
