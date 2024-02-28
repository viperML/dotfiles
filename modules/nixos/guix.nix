{
  services.guix = {
    enable = true;
    gc = {
      enable = true;
      dates = "weekly";
    };
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
}
