{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    # package = pkgs.vscode-with-extensions.override {
    #   vscodeExtensions = with pkgs.vscode-extensions; [
    #     ms-vsliveshare.vsliveshare
    #   ];
    # };
    keybindings = [];
    userSettings = {};
  };
}
