pkgs: let 
  inherit (pkgs) lib;
in {
  appName = "nvim-viper-mnw";
  desktopEntry = false;
  providers.python3.enable = false;
  providers.ruby.enable = false;

  extraLuaPackages = lp: [
    lp.luassert
    lp.luaposix
    lp.lyaml
  ];

  devExcludedPlugins = [
    ./viper-init-plugin
  ];

  devPluginPaths = [
    "~/Documents/dotfiles/packages/neovim/viper-init-plugin"
  ];

  plugins =
    let
      start =
        with pkgs.vimPlugins;
        [
          lz-n
          nvim-web-devicons
          snacks-nvim
          plenary-nvim
          mini-nvim
          kanagawa-nvim
          bufferline-nvim
          lualine-nvim
          # No autostart
          blink-cmp-copilot
          lsp-progress-nvim
          nui-nvim

          nvim-treesitter

          ./viper-init-plugin
        ]
        ++ (
          pkgs.vimPlugins.nvim-treesitter.grammarPlugins
          |> lib.filterAttrs (n: _: !(builtins.elem n [ "comment" ]))
          |> builtins.attrValues
        );

      opt = with pkgs.vimPlugins; [
        nvim-treesitter

        nvim-ts-autotag
        nvim-treesitter-context
        nvim-treesitter-textobjects

        # codecompanion-nvim
        avante-nvim
        copilot-lua
        comment-nvim
        conform-nvim
        git-conflict-nvim
        gitsigns-nvim
        haskell-tools-nvim
        indent-blankline-nvim
        marks-nvim
        neo-tree-nvim
        noice-nvim
        nvim-autopairs
        nvim-lspconfig
        blink-cmp
        nvim-navic
        parinfer-rust
        smart-splits-nvim
        telescope-fzf-native-nvim
        telescope-nvim
        trouble-nvim
        vim-better-whitespace
        vim-nix
        which-key-nvim
        yazi-nvim
      ];
    in
    start ++ (map (p: p // { optional = true; }) opt);
}
