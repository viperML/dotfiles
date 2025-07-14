{pkgs, ...}: {
  wrappers.ghostty = {
    basePackage = pkgs.ghostty;
    prependFlags = [
      "--config-file=${./config}"
    ];
  };
}
