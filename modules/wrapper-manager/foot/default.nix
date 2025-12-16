{pkgs, ...}: {
  wrappers.foot = {
    basePackage = pkgs.foot;
    prependFlags = ["--config=${./foot.ini}"];
  };
}
