{pkgs, ...}: {
  wrappers.google-chrome = {
    basePackage = pkgs.google-chrome;
    flags = [
      "--enable-features=WebUIDarkMode"
      "--force-dark-mode"
    ];
  };
}
