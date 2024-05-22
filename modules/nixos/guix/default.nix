{
  config,
  lib,
  ...
}: {
  services.guix = {
    enable = true;
    gc = {
      enable = true;
      dates = "weekly";
    };
    extraArgs = let
      substituters = [
        "https://ci.guix.gnu.org"
        # "https://bordeaux.guix.gnu.org"
        # "https://guix.bordeaux.inria.fr"
      ];
    in ["--substitute-urls=${lib.concatStringsSep " " substituters}"];
  };

  environment.extraInit = ''
    export GUILE_LOAD_PATH="$GUILE_LOAD_PATH:$HOME/.config/guix/current/share/guile/site/3.0"

    export GUILE_LOAD_COMPILED_PATH="$GUILE_LOAD_COMPILED_PATH:$HOME/.config/guix/current/share/guile/site/3.0"
    export GUILE_LOAD_COMPILED_PATH="$GUILE_LOAD_COMPILED_PATH:$HOME/.config/guix/current/lib/guile/3.0/site-ccache"
  '';

  # guix apps can't find these
  environment.sessionVariables = {
    SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    SSL_CERT_DIR = "/etc/ssl/certs";
  };

  systemd.services."guix-substituters" = rec {
    path = [config.services.guix.package];
    script = ''
      set -x
      guix archive --authorize < ${./guix.bordeaux.inria.fr.pub}
    '';
    wantedBy = ["guix-daemon.service"];
    after = wantedBy;
  };
}
