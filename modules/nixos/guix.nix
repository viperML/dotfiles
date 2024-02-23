{config, ...}: {
  services.guix = {
    enable = true;
    gc = {
      enable = true;
      dates = "weekly";
    };
  };

  # environment.extraInit = lib.mkAfter (let
  #   se = "$HOME/.guix-home/setup-environment";
  # in ''
  #   if [[ -f "${se}" ]]; then
  #     . "${se}"
  #   fi
  # '');
  environment.extraInit = ''
    export GUILE_LOAD_PATH="$GUILE_LOAD_PATH:$HOME/.config/guix/current/share/guile/site/3.0"

    export GUILE_LOAD_COMPILED_PATH="$GUILE_LOAD_COMPILED_PATH:$HOME/.config/guix/current/share/guile/site/3.0"
    export GUILE_LOAD_COMPILED_PATH="$GUILE_LOAD_COMPILED_PATH:$HOME/.config/guix/current/lib/guile/3.0/site-ccache"
  '';
}
