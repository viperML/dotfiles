{
  services.guix = {
    enable = true;
  };

  # environment.extraInit = lib.mkAfter (let
  #   se = "$HOME/.guix-home/setup-environment";
  # in ''
  #   if [[ -f "${se}" ]]; then
  #     . "${se}"
  #   fi
  # '');
}
