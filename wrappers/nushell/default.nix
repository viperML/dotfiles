{pkgs, ...}: {
  wrappers.nushell = {
    basePackage = pkgs.nushell;
    env.STARSHIP_CONFIG = {
      force = true;
      value = ./starship.toml;
    };
    flags = [
      "--env-config ${./env.nu}"
      "--config ${./config.nu}"
    ];
    pathAdd = [
      pkgs.starship
      pkgs.carapace
    ];
  };
}
