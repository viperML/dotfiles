{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace ((import ./extensions.nix).extensions);
  };

  home.packages = with pkgs; [
    nixpkgs-fmt
    rnix-lsp
  ];

  home.activation.vscode = {
    after = [ "writeBoundary" ];
    before = [ ];
    data = ''
      $DRY_RUN_CMD ln -sf $VERBOSE_ARG ${config.home.sessionVariables.FLAKE}/modules/home-manager/vscode/settings.json ~/.config/Code/User/settings.json
      $DRY_RUN_CMD ln -sf $VERBOSE_ARG ${config.home.sessionVariables.FLAKE}/modules/home-manager/vscode/keybindings.json ~/.config/Code/User/keybindings.json
      $DRY_RUN_CMD ln -sf $VERBOSE_ARG -t ~/.config/Code/User ${config.home.sessionVariables.FLAKE}/modules/home-manager/vscode/snippets
    '';
  };
}
