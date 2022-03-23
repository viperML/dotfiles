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
    # FIXME
    # https://github.com/starship/starship/issues/3771
    package = packages.nixpkgs-stable.fish;
    interactiveShellInit = ''
      ${pkgs.starship}/bin/starship init fish | source
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish | source

      ${builtins.readFile ./interactive.fish}
      ${builtins.readFile ./pushd-mod.fish}
    '';
    plugins = [
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
          rev = "17fcc74029bbd88445712752a5a71bc64aa3994c";
          sha256 = "12fyg3ycj3fqqms9b5ncnyyjs0gl54yc5qcbp5yp4p5fy5vwy6jr";
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
        name = "fish-async-prompt";
        src = pkgs.fetchFromGitHub {
          owner = "acomagu";
          repo = "fish-async-prompt";
          rev = "40f30a4048b81f03fa871942dcb1671ea0fe7a53";
          sha256 = "19i59145lsjmidqlgk2dmvs3vg2m3zlz2rcms2kyyk1m3y63q8xi";
        };
      }
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = false;
    config.whitelist.prefix = [
      "/home"
    ];
  };
}
