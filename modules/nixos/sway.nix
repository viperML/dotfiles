{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./wayland-compositors.nix
  ];

  home-manager.sharedModules = [
    inputs.self.homeModules.sway
  ];

  programs.sway = {
    enable = true;
    package = pkgs.sway.override {
      sway-unwrapped = pkgs.sway-unwrapped.overrideAttrs (_: {
        inherit (pkgs.swayfx) pname version src meta;
      });
      extraSessionCommands = ''
        source /etc/profile
      '';
      withGtkWrapper = false;
      isNixOS = true;
    };
    extraPackages = [];
  };

  xdg.portal.enable = true;
}
