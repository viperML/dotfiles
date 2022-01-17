{ config, pkgs, ... }:

{
  networking.stevenBlackHosts = {
    enable = false;
    blockFakenews = true;
    blockGambling = true;
  };

  networking.extraHosts = ''
    ${builtins.readFile "${pkgs.disconnect-tracking-protection}/hosts"}
  '';
}
