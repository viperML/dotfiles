{pkgs, ...}: {
  wrappers.helix = {
    basePackage = pkgs.helix;
    flags = ["-c" ./config.toml];
  };
}
