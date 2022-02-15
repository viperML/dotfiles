{
  config,
  pkgs,
  ...
}:
{
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;

    emacsPackagesOverlay = self: super: {
      # fixes https://github.com/vlaci/nix-doom-emacs/issues/394
      gitignore-mode = pkgs.emacsPackages.git-modes;
      gitconfig-mode = pkgs.emacsPackages.git-modes;
    };
  };

  home.packages =
    with pkgs; [
      emacs-all-the-icons-fonts
    ];
}
