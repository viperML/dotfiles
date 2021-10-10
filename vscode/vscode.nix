
{ config, pkgs, ... }:
{
  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscode-fhs;

  home.file.".config/Code/User/keybindings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/vscode/keybindings.json";
  home.file.".config/Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/vscode/settings.json";

}
