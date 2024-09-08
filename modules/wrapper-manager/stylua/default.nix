{pkgs, ...}: {
  wrappers.stylua = {
    basePackage = pkgs.stylua;
    flags = [
      "--config-path"
      ./stylua.toml
    ];
  };
}
