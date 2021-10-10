
{ config, pkgs, ... }:
{
  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscode-fhs;

  home.file.".config/Code/User/keybindings.json".source = ./keybindings.json;
  home.file.".config/Code/User/settings.json".source = ./settings.json;
  home.folder.".config/Code/User/snippets".source = ./snippets;

}
