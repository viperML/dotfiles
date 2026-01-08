{ pkgs, lib, ... }:
let
  fs = lib.fileset;
in
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
    dockerfile-language-server
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

  plugins = {
    dev.main = {
      pure =

        (
          fs.toSource {
            root = ./viper-init-plugin;
            fileset = lib.fileset.fromSource (lib.sources.cleanSource ./viper-init-plugin);
          }
        );
      impure = ./viper-init-plugin;
    };
    start = with pkgs.vimPlugins; [
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
      (nvim-treesitter.withPlugins (
        allPlugins:
        allPlugins
        |> lib.filterAttrs (
          n: _:
          !(builtins.elem n [
            # Disabled grammars
            "comment"
          ])
        )
        |> builtins.attrValues
      ))
      # nvim-treesitter-context
      # (nvim-treesitter-textobjects.overrideAttrs {
      #   doCheck = false;
      # })
      nvim-ts-autotag
      fidget-nvim
      haskell-tools-nvim

      # Some package before requires them
      telescope-fzf-native-nvim
      telescope-nvim
    ];

    opt = with pkgs.vimPlugins; [
      comment-nvim
      conform-nvim
      git-conflict-nvim
      gitsigns-nvim
      indent-blankline-nvim
      marks-nvim
      neo-tree-nvim
      noice-nvim
      nvim-autopairs
      nvim-lspconfig
      blink-cmp
      smart-splits-nvim
      # zellij-nav-nvim
      trouble-nvim
      vim-better-whitespace
      vim-nix
      which-key-nvim
      yazi-nvim
    ];
  };
  extraBuilderArgs = {
    doInstallCheck = true;
    installCheckPhase = ''
      export HOME="$(mktemp -d)"
      export NVIM_SILENT=1
      "$out/bin/nvim" --headless '+lua =require("viper.health").loaded_exit()' '+q'
    '';
  };
}
