{pkgs, ...}: {
  wrappers.foot = {
    basePackage = pkgs.foot;
    flags = ["--config=${./foot.ini}"];
  };
}
