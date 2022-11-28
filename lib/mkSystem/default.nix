{
  lib,
  inputs,
}: args:
with lib; let
  args' = filterAttrs (name: value:
    ! builtins.elem name [
      "lib"
      "specialisations"
      "nixosModules"
      "homeModules"
    ])
  args;

  defaultSpec = head (builtins.filter (s: s.default or false) args.specialisations);

  modules =
    (args.modules or [])
    ++ (args.nixosModules or [])
    ++ [
      ./common.nix
      ./systemd-boot.nix
      ./lib.nix
      inputs.nix-common.nixosModules.channels-to-flakes
      inputs.nix-common.nixosModules.hm-standalone-shim
      inputs.nix-common.nixosModules.xdg
      inputs.home-manager.nixosModules.home-manager
      {
        viper.defaultSpec = defaultSpec.name;
        home-manager.sharedModules = (args.homeModules or []) ++ [inputs.nix-common.homeModules.channels-to-flakes];
        home-manager.extraSpecialArgs = args.specialArgs;
        specialisation = listToAttrs (map (s:
          nameValuePair s.name {
            inheritParentConfig = true;
            configuration = {
              imports = s.nixosModules or [];
              environment.etc."specialisation".text = s.name;
              home-manager.sharedModules = s.homeModules or [];
            };
          })
        args.specialisations);
      }
    ];
in
  (args.lib.nixosSystem or lib.nixosSystem) (args' // {inherit modules;})
