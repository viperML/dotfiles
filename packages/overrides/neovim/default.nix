{
  sources,
  #
  vimUtils,
  vimPlugins,
  wrapNeovimUnstable,
  neovim-unwrapped,
  neovimUtils,
}: let
  sources' = builtins.attrValues (builtins.removeAttrs sources ["override" "overrideDerivation"]);
  nvfetcherPlugins = builtins.map (src: vimUtils.buildVimPlugin src) sources';
  config = neovimUtils.makeNeovimConfig {
    withPython3 = false;
    withNodeJs = false;
    withRuby = false;
    customRC = ''
      source ${./init.vim}
      :luafile ${./init.lua}
    '';
    plugins = with vimPlugins;
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

        (nvim-treesitter.withPlugins (tp: [
          tp.tree-sitter-bash
          tp.tree-sitter-dockerfile
          tp.tree-sitter-json
          tp.tree-sitter-json5
          tp.tree-sitter-python
          tp.tree-sitter-toml
          tp.tree-sitter-rust
          tp.tree-sitter-nix
        ]))
        vim-nix
        neoformat
      ];
  };
in
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/neovim/wrapper.nix
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/neovim/utils.nix
  wrapNeovimUnstable neovim-unwrapped (config
    // {
      wrapperArgs =
        config.wrapperArgs
        ++ [
          "--unset"
          "NIX_LD"
          "--unset"
          "NIX_LD_LIBRARY_PATH"
        ];
    })
