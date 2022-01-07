{ config, pkgs, ... }:

{
  home.persistence."/home/ayats/.impermanence" = {
    directories = [
      
    ];
    files = [
      ".ssh/known_hosts"
    ];
    allowOther = true;
  };
}
