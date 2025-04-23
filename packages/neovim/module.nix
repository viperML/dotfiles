{ pkgs, lib, ... }:
{
  appName = "nvim-viper-mnw";
  desktopEntry = false;
  providers.python3.enable = false;
  providers.ruby.enable = false;

  extraLuaPackages = lp: [
    lp.luassert
    lp.luaposix
    lp.lyaml
  ];

  extraBinPath = with pkgs; [
    vscode-langservers-extracted
    yaml-language-server
    taplo
    nodePackages.bash-language-server
  ];

  devExcludedPlugins = [
    ./viper-init-plugin
  ];

  devPluginPaths = [
    "~/Documents/dotfiles/packages/neovim/viper-init-plugin"
  ];

  wrapperArgs = [
    "--set-default"
    "NVIM_NODE"
    (lib.getExe (pkgs.nodejs.override { enableNpm = false; }))
  ];

  initLua =
    #lua
    ''
      vim.loader.enable(true)
      require("viper")
      vim.opt.exrc = true
    '';

  plugins =
    let
      start =
        with pkgs.vimPlugins;
        [
          nvim-web-devicons
          snacks-nvim
          plenary-nvim
          mini-nvim
          kanagawa-nvim
          catppuccin-nvim
          bufferline-nvim
          lualine-nvim

          # No autostart
          blink-cmp-copilot
          lsp-progress-nvim
          nui-nvim
          SchemaStore-nvim

          # Fine to not lazy-load
          lz-n
          nvim-treesitter
          nvim-treesitter-context
          nvim-treesitter-textobjects
          nvim-ts-autotag
          fidget-nvim

          ./viper-init-plugin
        ]
        ++ (
          pkgs.vimPlugins.nvim-treesitter.grammarPlugins
          |> lib.filterAttrs (n: _: !(builtins.elem n [ "comment" ]))
          |> builtins.attrValues
        );

      opt = with pkgs.vimPlugins; [

        # codecompanion-nvim
        avante-nvim
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
        # zellij-nav-nvim
        telescope-fzf-native-nvim
        telescope-nvim
        trouble-nvim
        vim-better-whitespace
        vim-nix
        which-key-nvim
        yazi-nvim

        # Check of having some autostart
        copilot-lua
      ];
    in
    start ++ (map (p: p // { optional = true; }) opt);
}
