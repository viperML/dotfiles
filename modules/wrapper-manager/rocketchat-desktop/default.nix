{ pkgs, ... }:
{
  wrappers.rocketchat-desktop = {
    basePackage = pkgs.rocketchat-desktop;
    prependFlags = [
      "--start-hidden"
    ];
  };
}
