{
  wrapNeovim,
  neovim-unwrapped,
  vimPlugins,
  vimUtils,
  formats,
  writeTextDir,
  fetchFromGitHub,
  lib,
}: let
  jsonFormat = formats.json {};
in
  wrapNeovim neovim-unwrapped {
    withNodeJs = true;
    withPython3 = true;
    configure.customRC = ''
      " Vanilla configs
      ${lib.fileContents ./vanilla.vim}

      " Plugins configs
      ${lib.fileContents ./plugins.vim}

      let g:coc_config_home="${writeTextDir "coc" (jsonFormat.generate "coc-settings.json" (import ./coc.nix))}"

      " Lua config
      :luafile ${./plugins.lua}
    '';
    configure.packages.plugins = with vimPlugins; let
      nvim-transparent = vimUtils.buildVimPlugin {
        pname = "nvim-transparent";
        version = "unstable-2022-04-13";
        src = fetchFromGitHub {
          owner = "xiyaowong";
          repo = "nvim-transparent";
          rev = "ed488bee61d544f9a52516c661f5df493253a1b4";
          sha256 = "08fnbqb10zxc6qwiswnqa5xf9g8k9q8pg5mwrl2ww2qcxnxbfw1p";
        };
        meta = {
          description = "Remove all background colors to make nvim transparent";
          homepage = "https://github.com/xiyaowong/nvim-transparent";
        };
      };
    in {
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
        nvim-transparent

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
