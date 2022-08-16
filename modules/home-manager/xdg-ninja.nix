{
  self,
  packages,
  ...
}: let
  template = import "${self}/modules/nixos/xdg-ninja/template.nix" "home-manager";
in {
  home.sessionVariables = template.env;
  home.packages = [packages.self.xdg-ninja];
  xdg.configFile = {
    inherit (template) npmrc;
    "python/pythonrc" = template.pythonrc;
  };
}
