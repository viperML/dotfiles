{
  wrapNeovim,
  neovim-unwrapped,
  vimPlugins,
  vimExtraPlugins,
  formats,
  writeTextDir,
  ...
}: let
  jsonFormat = formats.json {};
in
  wrapNeovim neovim-unwrapped {
    withNodeJs = true;
    withPython3 = true;
    configure.customRC = ''
      " Vanilla configs
      ${builtins.readFile ./vanilla.vim}

      " Plugins configs
      ${builtins.readFile ./plugins.vim}

      let g:coc_config_home="${writeTextDir "coc" (jsonFormat.generate "coc-settings.json" (import ./coc.nix))}"

      " Lua config
      :luafile ${./plugins.lua}
    '';
    configure.packages.plugins = with vimPlugins; {
      start = [
        vim-one

        nvim-web-devicons
        gitsigns-nvim
        bufferline-nvim
        lualine-nvim

        # Treesitter is quite broken + bloat
        # nvim-treesitter

        vim-highlightedyank
        indent-blankline-nvim
        auto-pairs
        nvim-comment
        editorconfig-vim
        vimExtraPlugins.nvim-transparent

        # LSP and comp
        nvim-lspconfig
        vim-nix
        coc-nvim
      ];
      # Packages that might be lazy-loaded
      # with :packadd <name>
      opt = [];
    };
  }
