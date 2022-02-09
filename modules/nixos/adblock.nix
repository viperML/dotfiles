{ config
, pkgs
, inputs
, ...
}:
{
  networking.extraHosts = ''
    ${builtins.readFile "${pkgs.stevenblack-hosts}/hosts"}
  '';
}
