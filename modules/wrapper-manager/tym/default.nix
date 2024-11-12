{pkgs, ...}: {
  wrappers.tym = {
    basePackage = pkgs.tym;
    flags = [
      "--use=${./config.lua}"
    ];
  };
}
