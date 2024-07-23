{pkgs, ...}: {
  wrappers.vscode = {
    basePackage = pkgs.vscode;
    env.NIXOS_OZONE_WL = {
      value = "1";
    };
  };
}
