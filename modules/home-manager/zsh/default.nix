{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    # enableAutosuggestions = true;
    # enableSyntaxHighlighting = true;
    dotDir = ".config/zsh";

    initExtra = ''
      eval "$(${pkgs.starship}/bin/starship init zsh)"
    '';

    prezto = {
      enable = true;
      editor.keymap = "emacs";
      utility.safeOps = true;
      pmodules = [
        "autosuggestions"
        "command-not-found"
        "completion"
        "directory"
        # "editor"
        "environment"
        "history"
        # "prompt"
        "syntax-highlighting"
        "spectrum"
        "terminal"
        "utility"
      ];
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = false;
    config.whitelist.prefix = [
      "/home"
    ];
  };
}
