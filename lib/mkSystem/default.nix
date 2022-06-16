lib: args:
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
      ./systemd-boot.nix
      {
        home-manager.sharedModules = args.homeModules or [];
        viper.defaultSpec = defaultSpec.name;
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
  (args.lib.nixosSystem or nixosSystem) (args' // {inherit modules;})
