{ lib
, config
, ...
}: {
  # home.sessionVariables.GUILE_LOAD_PATH = lib.concatMapStringsSep ":" (p: "${config.home.homeDirectory}/.guix-home/profile/${p}") [
  #   "share/guile/3.0"
  #   "share/guile/site/3.0"
  # ];

  home.file.".guile".text = ''
    (use-modules (ice-9 readline) (ice-9 colorized))

    (activate-readline)
    (activate-colorized)
  '';
}
