{ config, pkgs, ... }:

{
  networking.stevenBlackHosts = {
    enable = true;
    blockFakenews = true;
    blockGambling = true;
  };
}
