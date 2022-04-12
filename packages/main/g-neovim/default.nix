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
        # Theming
        vim-one
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
        vimExtraPlugins.nvim-transparent

        # Intelligent editor
        nvim-lspconfig
        vim-nix
        coc-nvim
        neoformat
      ];
      # Packages that might be lazy-loaded
      # with :packadd <name>
      opt = [];
    };
  }
