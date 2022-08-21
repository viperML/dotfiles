{
  withSystem,
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations = {
    "gen6" = withSystem "x86_64-linux" (
      {
        pkgs,
        system,
        ...
      }:
        self.lib.mkSystem {
          inherit system pkgs;
          nixosModules = with self.nixosModules; [
            ./gen6/configuration.nix
            desktop
            xdg-ninja

            virt
            docker
            # podman
            printing
            ld
            flatpak

            ./gen6/nspawn.nix

            ./gen6/fix-bluetooth.nix
            inputs.nix-gaming.nixosModules.pipewireLowLatency
            {
              services.pipewire.lowLatency.enable = true;
            }
          ];
          homeModules = with self.homeModules; [
            ./gen6/home.nix
            common
            xdg-ninja
            gui
            vscode
            wezterm
            nh
            flatpak
          ];
          specialisations = [
            (self.lib.joinSpecialisations (with self.specialisations; [
              kde
              nvidia
              ayats
              default
            ]))
          ];
        }
    );
  };
}
