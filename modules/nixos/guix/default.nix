{
  config,
  lib,
  self',
  ...
}: {
  services.guix = {
    enable = true;
    package = self'.packages.guix;
    gc = {
      enable = true;
      dates = "weekly";
    };
    extraArgs = let
      substituters = [
        "https://ci.guix.gnu.org"
        "https://bordeaux.guix.gnu.org"
        # "https://guix.bordeaux.inria.fr"
      ];
    in [
      "--substitute-urls=${lib.concatStringsSep " " substituters}"
      "-c"
      "10"
    ];
  };

  environment.extraInit =
    # bash
    ''
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

  systemd.services."guix-daemon" = {
    environment = {
      # GUIX_LOCPATH = lib.mkForce "/run/current-system/sw/lib/locale";
      # GUIX_LOCPATH = lib.mkForce "/gnu/store/03v1svhv6wj9pd6awpdi5zn4wd31b23f-glibc-locales-2.35/lib/locale";
    };
  };
}
