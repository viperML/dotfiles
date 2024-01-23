{pkgs, ...}: {
  wrappers.bat = {
    basePackage = pkgs.bat;
    flags = [
      "--theme=base16"
      "--style=changes,header"
      "--plain"
    ];
  };
}
