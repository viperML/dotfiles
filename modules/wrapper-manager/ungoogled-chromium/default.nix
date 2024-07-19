{ pkgs, lib, ...}: {
  wrappers.ungoogled-chromium = {
    basePackage = pkgs.ungoogled-chromium;
    env.NIXOS_OZONE_WL = {
      force = true;
      value = null;
    };
    flags = [
      "--enable-features=${
        lib.concatStringsSep "," [
          "ClearDataOnExit"
          "WebUIDarkMode"
          "WaylandWindowDecorations"
        ]
      }"
      "--ozone-platform-hint=auto"
      "--force-dark-mode"
    ];
  };
}
