{pkgs, ...}: {
  wrappers.bat = {
    basePackage = pkgs.bat;
    flags = [
      "--theme=ansi"
      "--style=changes,header"
      "--plain"
      "--paging=auto"
    ];
  };
}
