{
  config,
  lib,
  self',
  pkgs,
  options,
  ...
}:
let
  cfg = config.services.guix;
in
{
  services.guix = {
    enable = true;
    package = self'.packages.guix;
    gc = {
      enable = true;
      dates = "weekly";
    };
    substituters = {
      urls = options.services.guix.substituters.urls.default ++ [
        "https://bordeaux.guix.gnu.org"
        "https://guix.bordeaux.inria.fr"
      ];
      authorizedKeys = options.services.guix.substituters.authorizedKeys.default ++ [
        ./guix.bordeaux.inria.fr.pub
      ];
    };
  };

  systemd.services.guix-daemon = {
    # use the system guix for the daemon
    script = lib.mkForce ''
      exec ${lib.getExe' self'.packages.guix "guix-daemon"} \
        --build-users-group=${cfg.group} \
        ${
          lib.optionalString (
            cfg.substituters.urls != [ ]
          ) "--substitute-urls='${lib.concatStringsSep " " cfg.substituters.urls}'"
        } \
        ${lib.escapeShellArgs cfg.extraArgs}
    '';
  };

  environment.extraInit =
    # bash
    ''
      export GUILE_LOAD_PATH="$GUILE_LOAD_PATH:$HOME/.config/guix/current/share/guile/site/3.0"

      export GUILE_LOAD_COMPILED_PATH="$GUILE_LOAD_COMPILED_PATH:$HOME/.config/guix/current/share/guile/site/3.0"
      export GUILE_LOAD_COMPILED_PATH="$GUILE_LOAD_COMPILED_PATH:$HOME/.config/guix/current/lib/guile/3.0/site-ccache"

      export GUIX_LOCPATH="/var/guix/profiles/per-user/$USER/guix-home/profile/lib/locale:$GUIX_LOCPATH"
    '';

  # https://guix.gnu.org/manual/en/html_node/X_002e509-Certificates.html
  environment.sessionVariables =
    let
      SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    in
    {
      SSL_CERT_DIR = "/etc/ssl/certs";
      inherit SSL_CERT_FILE;
      GIT_SSL_CAINFO = SSL_CERT_FILE;
      CURL_CA_BUNDLE = SSL_CERT_FILE;
    };

  systemd.services."guix-daemon" = {
    environment = {
      # GUIX_LOCPATH = lib.mkForce "/run/current-system/sw/lib/locale";
      # GUIX_LOCPATH = lib.mkForce "/gnu/store/03v1svhv6wj9pd6awpdi5zn4wd31b23f-glibc-locales-2.35/lib/locale";
    };
  };
}
