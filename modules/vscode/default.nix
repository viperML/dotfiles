{ config, pkgs, ... }:

{
  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscode-fhs;

  # Using symlinks to .dotdir instead of the nix store
  # VSCode is a pain to configure in declarative way
  # TODO - apparently we cannot reference relatives files from here
  home.file.".config/Code/User/keybindings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/vscode/keybindings.json";
  home.file.".config/Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/vscode/settings.json";
  home.file.".config/Code/User/snippets/bibtex.code-snippets".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/vscode/snippets/bibtex.code-snippets";
  home.file.".config/Code/User/snippets/latex.code-snippets".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/vscode/snippets/latex.code-snippets";
  home.file.".config/Code/User/snippets/service.code-snippets".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/vscode/snippets/service.code-snippets";
}
