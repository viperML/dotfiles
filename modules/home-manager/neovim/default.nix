{ config
, pkgs
, ...
}:
# Requires https://github.com/m15a/nixpkgs-vim-extra-plugins overlay
{
  home.sessionVariables.EDITOR = "${config.programs.neovim.package.outPath}/bin/nvim";

  programs.neovim = {
    enable = true;

    extraConfig =
      let
        plugins-lua = pkgs.writeTextFile {
          name = "plugins-lua";
          text = "${builtins.readFile ./plugins.lua}";
        };
      in
        ''
          " Vanilla configs
          ${builtins.readFile ./vanilla.vim}

          " Plugins configs
          ${builtins.readFile ./plugins.vim}

          " Lua config
          :luafile ${plugins-lua}
        '';

    withNodeJs = true;

    extraPackages =
      with pkgs;
      [
        tree-sitter
        # nixpkgs-fmt
        rnix-lsp
        xsel
      ];

    coc = {
      enable = true;
      settings = "${builtins.readFile ./coc-settings.json}";
    };

    plugins =
      with pkgs.vimPlugins;
      with pkgs.vimExtraPlugins;
      # Some pkgs must be derivated from source
      let
        context-vim = pkgs.vimUtils.buildVimPlugin {
          name = "context-vim";
          src = pkgs.fetchFromGitHub {
            owner = "wellle";
            repo = "context.vim";
            rev = "e38496f1eb5bb52b1022e5c1f694e9be61c3714c";
            sha256 = "1iy614py9qz4rwk9p4pr1ci0m1lvxil0xiv3ymqzhqrw5l55n346";
          };
        };
      in
        [
          # Visual
          nvim-transparent
          # context-vim
          # vim-airline
          vim-highlightedyank
          dracula-vim
          vim-one
          bufferline-nvim
          feline-nvim
          nvim-web-devicons
          gitsigns-nvim
          indent-blankline-nvim
          nvim-tree-lua

          # Misc
          vim-easymotion
          auto-pairs
          nvim-comment
          editorconfig-vim

          # Completion and syntax
          # coc-nvim
          # coc-json
          vim-nix
          nvim-lspconfig
          nvim-treesitter
        ];
  };
}
