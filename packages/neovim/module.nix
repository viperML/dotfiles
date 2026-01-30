{ pkgs, ... }:
{
  appName = "nvim-viper-mnw";
  desktopEntry = false;

  extraBinPath = with pkgs; [
    vscode-langservers-extracted
    yaml-language-server
    taplo
    nodePackages.bash-language-server
    dockerfile-language-server
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
      pure = pkgs.nix-gitignore.gitignoreSourcePure [ ../../.gitignore ] ./viper-init-plugin;
      impure = ./viper-init-plugin;
    };
    start = with pkgs.vimPlugins; [
      lz-n

      # lsp.lua
      nvim-lspconfig
      SchemaStore-nvim
      blink-cmp

      # visual.lua
      mini-icons
      gruvbox-nvim
    ];

    opt = with pkgs.vimPlugins; [
      # visual.lua
      which-key-nvim
    ];
  };
  extraBuilderArgs = {
    doInstallCheck = true;
    installCheckPhase = ''
      export HOME="$(mktemp -d)"
      "$out/bin/nvim" --headless '+lua =require("viper.health").loaded_exit()' '+q'
    '';
  };
}
