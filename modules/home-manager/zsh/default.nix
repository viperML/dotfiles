{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    dotDir = ".config/zsh";

    initExtra = ''
      eval "$(${pkgs.starship}/bin/starship init zsh)"
      ${lib.fileContents ./init.zsh}
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = false;
    config.whitelist.prefix = [
      "/home"
    ];
  };
}
