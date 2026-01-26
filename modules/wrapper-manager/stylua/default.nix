{pkgs, ...}: {
  wrappers.stylua = {
    basePackage = pkgs.stylua;
    prependFlags = [
      "--config-path"
      ./stylua.toml
    ];
  };
}
