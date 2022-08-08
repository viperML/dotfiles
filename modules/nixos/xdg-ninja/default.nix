{packages, ...}: let
  template = import ./template.nix "nixos";
in {
  environment.systemPackages = [packages.self.xdg-ninja];
  environment.sessionVariables = template.env;

  environment.etc = {
    inherit (template) pythonrc npmrc;
  };
}
