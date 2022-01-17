{ config, pkgs, inputs, ... }:

{
  networking.extraHosts = ''
    ${builtins.readFile "${pkgs.stevenblack-hosts}/hosts"}
    ${builtins.readFile "${pkgs.disconnect-tracking-protection}/hosts"}
  '';
}
