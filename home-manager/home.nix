{ config, pkgs, ... }:

{

  home.username = "ayats";
  home.homeDirectory = "/home/ayats";

  home.packages = with pkgs; [
    # Neovim dependencies
    nix-prefetch-scripts
    luajitPackages.luacheck
    nodejs

    fzf
    lsd
    bat
    ripgrep
    fd
    starship
  ];


  programs.home-manager = {
    enable = true;
    path = "…";
  };

  programs.fish = {
    enable = true;
    promptInit = "starship init fish | source";
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
     ];
  };
  
  programs.neovim = {
      enable = true;
      extraConfig = ''
        " Vanilla configs
        ${builtins.readFile ../neovim/base.vim}

        " Plugins configs
        ${builtins.readFile ../neovim/plugins.vim}
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
            version = "2021-08-01";
            src = pkgs.fetchFromGitHub {
              owner = "terrortylor";
              repo = "nvim-comment";
              rev = "6363118acf86824ed11c2238292b72dc5ef8bdde";
              sha256 = "039fznaldf6lzk0yp51wi7p1j3l5rvhwryvk5s3lrq78lxq2rzn2";
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
          coc-nvim
        ];

    };
}
