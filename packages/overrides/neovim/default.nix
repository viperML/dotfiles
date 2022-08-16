{
  sources,
  #
  neovim,
  neovimUtils,
  vimUtils,
  vimPlugins,
}: let
  sources' = builtins.attrValues (builtins.removeAttrs sources ["override" "overrideDerivation"]);
  nvfetcherPlugins = builtins.map (src: vimUtils.buildVimPlugin src) sources';
in
  # https://nixos.org/manual/nixpkgs/unstable/#custom-configuration
  neovim.override {
    extraMakeWrapperArgs = "--unset NIX_LD --unset NIX_LD_LIBRARY_PATH";
    withPython3 = false;
    withNodeJs = false;
    withRuby = false;
    configure = {
      customRC = ''
        source ${./init.vim}
        :luafile ${./init.lua}
      '';
      BIG_PACKAGE.start = with vimPlugins;
        nvfetcherPlugins
        ++ [
          # Theming
          # vim-one
          nvim-web-devicons
          gitsigns-nvim
          bufferline-nvim
          lualine-nvim

          # Misc
          vim-highlightedyank
          indent-blankline-nvim
          auto-pairs
          nvim-comment
          editorconfig-vim

          # Intelligent editor
          nvim-lspconfig
          nvim-cmp
          cmp-cmdline
          cmp-nvim-lsp
          cmp-buffer
          cmp-path

          nvim-treesitter'
          vim-nix
          neoformat
        ];
    };
  }
