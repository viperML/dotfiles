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
    plugins = with pkgs; [
      {
        name = "fzf.fish";
        src = fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "fdc1f4043b1ff4da76bb7c0a6a4f19084e9213ef";
          sha256 = "1m5gqnjmm0gm906mrhl54pwmjpqfbjims7zvjk4hyhyx45hi94m8";
        };
      }
      {
        name = "sponge";
        src = fetchFromGitHub {
          owner = "andreiborisov";
          repo = "sponge";
          rev = "0f3bf8f10b81b25d2b3bbb3d6ec86f77408c0908";
          sha256 = "0vsi872c58z7zzdr0kzfsx49fi7241dakjdp6h1ff3wfzw2zsi0i";
        };
      }
    ];
  };

  home.sessionVariables.MANPAGER = "sh -c 'col -bx | bat --paging=always -l man -p'";
  xdg.configFile."bat/config".source = ./bat-config;
  xdg.configFile."starship.toml".source = ./starship.toml;
}
