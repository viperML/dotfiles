{ config, pkgs, ... }:

{

  home.username = "ayats";
  home.homeDirectory = "/home/ayats";

  home.packages = [
    pkgs.nix-prefetch-scripts
    pkgs.luajitPackages.luacheck
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
          context-vim = pkgs.vimUtils.buildVimPlugin {
            name = "context-vim";
            src = pkgs.fetchFromGitHub {
              owner = "wellle";
              repo = "context.vim";
              rev = "e38496f1eb5bb52b1022e5c1f694e9be61c3714c";
              sha256 = "1iy614py9qz4rwk9p4pr1ci0m1lvxil0xiv3ymqzhqrw5l55n346";
            };
          };
  nvim-comment = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "nvim-comment";
    version = "2021-04-26";
    src = pkgs.fetchFromGitHub {
      owner = "terrortylor";
      repo = "nvim-comment";
      rev = "e7de7abf17204424065b926a9031f44b47efbf4a";
      sha256 = "19m31sjmpn590y5rzs2mgkgqij5hr6v5hnvw30qfh3fjgm3j7fdi";
    };
  };

        in [
          nvim-transparent
          dracula-vim
          editorconfig-nvim
          context-vim
          vim-airline
          vim-easymotion
          auto-pairs
          vim-highlightedyank
          nvim-comment
        ];

    };
}
