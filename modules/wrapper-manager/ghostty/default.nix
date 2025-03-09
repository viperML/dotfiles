{pkgs, ...}: {
  wrappers.ghostty = {
    basePackage = pkgs.ghostty;
    flags = [
      "--config-file=${./config}"
    ];
  };
}
