{
  config,
  pkgs,
  lib,
  self,
  ...
}: let
  # The flake can't know it's own location (~/Documents/dotfiles in my case)
  selfPath =
    if lib.hasAttr "FLAKE" config.home.sessionVariables
    # If we know the location, symlink to the flake so config is mutable
    # e.g. ~/.config/Code/User/settings.json -> ~/Documents/dotfiles/modules/home-manager/vscode/settings.json
    then "${config.home.sessionVariables.FLAKE}/modules/home-manager/vscode"
    # Else, symlink into the nix store
    # e.g. ~/.config/Code/User/settings.json -> /nix/store/...-source
    else "${self.outPath}/modules/home-manager/vscode";
  # or just hardcode a path into selfPath...

  vscodePath = "${config.xdg.configHome}/Code/User";
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = import ./extensions {inherit pkgs;};
    # Make sure home-manager doesn't interfere with my settings
    keybindings = [];
    userSettings = {};
  };

  home.packages = [
    pkgs.rnix-lsp
  ];

  home.activation.vscode = {
    after = ["writeBoundary"];
    before = [];
    # Wipe mutable extensions, so we only have declaratively installed extensions
    data = ''
      $DRY_RUN_CMD find $HOME/.vscode/extensions -maxdepth 1 -mindepth 1 -type d -exec rm -rf $VERBOSE_ARG {} \;
    '';
  };

  systemd.user.tmpfiles.rules = [
    "L+ ${vscodePath}/settings.json - - - - ${selfPath}/settings.json"
    "L+ ${vscodePath}/keybindings.json - - - - ${selfPath}/keybindings.json"
    "L+ ${vscodePath}/snippets - - - - ${selfPath}/snippets"
  ];
}
