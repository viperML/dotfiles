{ config, pkgs, ... }:

{

  home.username = "ayats";
  home.homeDirectory = "/home/ayats";

  home.packages = [
    pkgs.nix-prefetch-scripts
  ];


  programs.home-manager = {
    enable = true;
    path = "…";
  };
  
  programs.neovim = {
      enable = true;
      extraConfig = ''
        " Vanilla configs
        ${builtins.readFile ./neovim/base.vim}

        " Plugins configs
        ${builtins.readFile ./neovim/plugins.vim}
      '';
      

      plugins = with pkgs.vimPlugins;
        let
          nvim-transparent = pkgs.vimUtils.buildVimPlugin {
            name = "nvim-transparent";
            src = pkgs.fetchFromGitHub {
              owner = "xiyaowong";
              repo = "nvim-transparent";
              rev = "9441bc7b03a31ccf301b984e36f0c4b4db4974a5";
              sha256 = "0l0fj2ifxl9p7z7cyn64a64wihl1ypddxsxdbgym5f2akjdbcqsr";
            };
          };
        in [
          nvim-transparent
          dracula-vim
          editorconfig-nvim
          context-vim
          vim-airline
        ];

    };
}
