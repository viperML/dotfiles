{self, ...}: let
  template = import "${self}/modules/nixos/xdg-ninja/template.nix" "home-manager";
in {
  home.sessionVariables = template.env;
  xdg.configFile = {
    inherit (template) npmrc pythonrc;
  };
}
