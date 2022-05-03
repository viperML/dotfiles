{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    keybindings = [];
    userSettings = {};
  };
}
