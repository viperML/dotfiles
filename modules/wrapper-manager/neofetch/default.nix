{pkgs, ...}: {
  wrappers.neofetch = {
    basePackage = pkgs.neofetch.override {x11Support = false;};
    flags = ["--config" ./config.sh "--ascii" ./logo];
  };
}
