{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhs;
  };

  home.file.".config/Code/User/keybindings.json".source = config.lib.file.mkOutOfStoreSymlink ./keybindings.json;
  home.file.".config/Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink ./settings.json;
  home.file.".config/Code/User/snipptes".source = config.lib.file.mkOutOfStoreSymlink ./snippets;
}
