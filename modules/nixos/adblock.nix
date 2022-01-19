{ config, pkgs, inputs, ... }:

{
  networking.extraHosts = ''
    ${builtins.readFile "${pkgs.disconnect-tracking-protection}/hosts"}
    ${builtins.readFile "${pkgs.stevenblack-hosts}/hosts"}
  '';
}
