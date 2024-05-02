{
  packages,
  inputs,
  ...
}: {
  imports = [./wayland-compositors.nix];

  home-manager.sharedModules = [inputs.self.homeModules.sway {wayland.windowManager.sway.fx = true;}];

  programs.sway = {
    enable = true;
    package = packages.self.sway-custom;
    extraPackages = [];
  };
}
