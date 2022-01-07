{ config, pkgs, ... }:

{
  home.persistence."/home/ayats/.impermanence" = {
    directories = [
      ".local/share/keyrings"
    ];
    files = [
      ".ssh/known_hosts"
    ];
    allowOther = true;
  };
}
