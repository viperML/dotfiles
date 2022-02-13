{ config
, pkgs
, lib
, ...
}:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = import ./extensions { inherit pkgs; };
    keybindings = [ ];
    userSettings = { };
  };

  home.packages =
    with pkgs; [
      # nixpkgs-fmt
      rnix-lsp
      # sumneko-lua-language-server
    ];

  home.activation.vscode =
    if (lib.hasAttr "FLAKE" config.home.sessionVariables)
    then
      {
        after = [ "writeBoundary" ];
        before = [ ];
        data = ''
          $DRY_RUN_CMD ln -sf $VERBOSE_ARG ${
          config.home.sessionVariables.FLAKE
        }/modules/home-manager/vscode/settings.json ~/.config/Code/User/settings.json
          $DRY_RUN_CMD ln -sf $VERBOSE_ARG ${
          config.home.sessionVariables.FLAKE
        }/modules/home-manager/vscode/keybindings.json ~/.config/Code/User/keybindings.json
          $DRY_RUN_CMD ln -sf $VERBOSE_ARG -t ~/.config/Code/User ${
          config.home.sessionVariables.FLAKE
        }/modules/home-manager/vscode/snippets
          $DRY_RUN_CMD find $HOME/.vscode/extensions -maxdepth 1 -mindepth 1 -type d -exec rm -rf $VERBOSE_ARG {} \;
        '';
      }
    else
      (
        throw "The implementation to import this module (vscode) is not finished"
      );
}
