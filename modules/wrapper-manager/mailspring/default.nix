{ pkgs, ... }:
{
  wrappers.mailspring = {
    basePackage = pkgs.mailspring;
    prependFlags = [ "--background" ];
  };
}
