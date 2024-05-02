{pkgs, ...}: let
  nvfetcher = builtins.mapAttrs (name: value:
    pkgs.vimUtils.buildVimPlugin {
      inherit name;
      inherit (value) src;
    }) (pkgs.callPackages ./generated.nix {});
  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    withPython3 = false;
    withRuby = false;
    withNodeJs = false;
    customRC = ''
      source ${./init.vim}
      :luafile ${./init.lua}
    '';
    plugins =
      (builtins.attrValues nvfetcher)
      ++ (with pkgs.vimPlugins; [
        # All
        bufferline-nvim
        lualine-nvim
        nvim-web-devicons
        gitsigns-nvim
        vim-highlightedyank
        indent-blankline-nvim-lua
        nvim-autopairs
        neoformat
        neo-tree-nvim
        comment-nvim
        which-key-nvim

        # Language support
        nvim-lspconfig
        nvim-cmp
        cmp-cmdline
        cmp-nvim-lsp
        cmp-buffer
        cmp-path

        nvim-treesitter.withAllGrammars
        # missing grammars break
        # (nvim-treesitter.withPlugins (tp: [
        #   tp.tree-sitter-bash
        #   tp.tree-sitter-dockerfile
        #   tp.tree-sitter-json
        #   tp.tree-sitter-json5
        #   tp.tree-sitter-python
        #   tp.tree-sitter-toml
        #   tp.tree-sitter-rust
        #   tp.tree-sitter-nix
        # ]))

        vim-nix
        conjure
        cmp-conjure
        parinfer-rust
        orgmode

        ## -- Unsorted
      ]);
  };
in {
  wrappers.neovim = {
    basePackage = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped neovimConfig;
  };
}
