{
  vimPlugins,
  vimUtils,
  callPackages,
  neovimUtils,
  wrapNeovimUnstable,
  neovim-unwrapped,
  ...
}: let
  nvfetcher = builtins.mapAttrs (name: value:
    vimUtils.buildVimPlugin {
      inherit name;
      inherit (value) src;
    }) (callPackages ./generated.nix {});

  neovimConfig = neovimUtils.makeNeovimConfig {
    withPython3 = false;
    withRuby = false;
    withNodeJs = false;

    customRC = ''
      source ${./init.vim}
      :luafile ${./init.lua}
    '';

    plugins =
      (builtins.attrValues nvfetcher)
      ++ (with vimPlugins; [
        # All
        bufferline-nvim
        lualine-nvim
        nvim-web-devicons
        gitsigns-nvim
        vim-highlightedyank
        indent-blankline-nvim-lua
        nvim-autopairs
        neo-tree-nvim
        comment-nvim
        which-key-nvim
        conform-nvim
        telescope-nvim

        # Language support
        nvim-lspconfig
        nvim-cmp
        cmp-cmdline
        cmp-nvim-lsp
        cmp-buffer
        cmp-path

        # nvim-treesitter.withAllGrammars
        (nvim-treesitter.withPlugins (tsg: [
          tsg.tree-sitter-bash
          tsg.tree-sitter-c
          tsg.tree-sitter-cmake
          tsg.tree-sitter-cpp
          tsg.tree-sitter-css
          tsg.tree-sitter-elisp
          tsg.tree-sitter-fish
          tsg.tree-sitter-hcl
          tsg.tree-sitter-html
          tsg.tree-sitter-javascript
          tsg.tree-sitter-jsdoc
          tsg.tree-sitter-json
          tsg.tree-sitter-json5
          tsg.tree-sitter-just
          tsg.tree-sitter-latex
          tsg.tree-sitter-lua
          tsg.tree-sitter-make
          tsg.tree-sitter-markdown
          tsg.tree-sitter-markdown-inline
          tsg.tree-sitter-nix
          tsg.tree-sitter-nu
          tsg.tree-sitter-org-nvim
          tsg.tree-sitter-python
          tsg.tree-sitter-rust
          tsg.tree-sitter-scheme
          tsg.tree-sitter-scss
          tsg.tree-sitter-toml
          tsg.tree-sitter-tsx
          tsg.tree-sitter-typescript
          tsg.tree-sitter-typst
          tsg.tree-sitter-vim
          tsg.tree-sitter-yaml
        ]))

        vim-nix
        # conjure
        # cmp-conjure
        orgmode
        parinfer-rust
        nvim-paredit

        ## -- Unsorted
      ]);
  };
in
  wrapNeovimUnstable neovim-unwrapped neovimConfig
