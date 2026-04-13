{ pkgs, ... }:
{
  wrappers.mailspring = {
    basePackage = pkgs.mailspring;
    prependFlags = [
      "--background"
      "--password-store=gnome-libsecret"
    ];
  };
}
