{pkgs, ...}: {
  wrappers.alacritty = {
    basePackage = pkgs.alacritty;
    flags = [
      "--config-file"
      ./alacritty.toml
    ];
  };
}
