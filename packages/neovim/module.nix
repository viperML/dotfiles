{ pkgs, lib, ... }:
let
  fs = lib.fileset;
in
{
  appName = "nvim-viper-mnw";
  desktopEntry = false;

  extraLuaPackages = lp: [
  ];

  extraBinPath = with pkgs; [
    vscode-langservers-extracted
    yaml-language-server
    taplo
    nodePackages.bash-language-server
    dockerfile-language-server
  ];

  # wrapperArgs = [
  #   "--set-default"
  #   "NVIM_NODE"
  #   (lib.getExe (pkgs.nodejs.override { enableNpm = false; }))
  # ];

  initLua =
    #lua
    ''
      vim.loader.enable(true)
      require("viper")
      vim.opt.exrc = true
    '';

  plugins = {
    dev.main = {
      pure = pkgs.nix-gitignore.gitignoreSource [ ../../.gitignore ] ./viper-init-plugin;
      impure = ./viper-init-plugin;
    };
    start = with pkgs.vimPlugins; [
      lz-n

      # lsp.lua
      nvim-lspconfig
      SchemaStore-nvim
      blink-cmp
    ];

    opt = with pkgs.vimPlugins; [
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
