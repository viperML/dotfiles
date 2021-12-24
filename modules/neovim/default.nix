{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # Needed to compile nvim-comment
    luajitPackages.luacheck

    # COC runtime dependency
    nodejs

    nixpkgs-fmt
    rnix-lsp
  ];

  home.file.".config/nvim/coc-settings.json".source = ./coc-settings.json;

  home.sessionVariables.EDITOR = "neovim";

  programs.neovim = {
    enable = true;
    extraConfig = ''
      " Vanilla configs
      ${builtins.readFile ./base.vim}

      " Plugins configs
      ${builtins.readFile ./plugins.vim}
    '';


    plugins = with pkgs.vimPlugins;
      # Some pkgs must be derivated from source
      let
        nvim-transparent = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-transparent";
          src = pkgs.fetchFromGitHub {
            owner = "xiyaowong";
            repo = "nvim-transparent";
            rev = "d171ca7ab4215e0276899b19fd808afa84acc9ab";
            sha256 = "1fh1klw89i8hs5y2xfbyf6nmc9j4f70jhgd09j5cyciz6zidq0sj";
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
          version = "unstable-2021-08-01";
          src = pkgs.fetchFromGitHub {
            owner = "terrortylor";
            repo = "nvim-comment";
            rev = "6363118acf86824ed11c2238292b72dc5ef8bdde";
            sha256 = "039fznaldf6lzk0yp51wi7p1j3l5rvhwryvk5s3lrq78lxq2rzn2";
          };
        };
        copilot-vim = pkgs.vimUtils.buildVimPlugin {
          name = "copilot-vim";
          src = pkgs.fetchFromGitHub {
            owner = "github";
            repo = "copilot.vim";
            rev = "c01314840b94da0b9767b52f8a4bbc579214e509";
            sha256 = "10vw2hjrg20i8id5wld8c5b1m96fnxvkb5qhbdf9w5sagawn4wc2";
          };
        };

      in
      [
        # Visual
        nvim-transparent
        context-vim
        vim-airline
        vim-highlightedyank
        dracula-vim

        # Misc
        vim-easymotion
        auto-pairs
        nvim-comment
        editorconfig-vim

        # Completion and syntax
        coc-nvim
        coc-json
        vim-nix
        nvim-lspconfig
        copilot-vim
      ];

  };
}
