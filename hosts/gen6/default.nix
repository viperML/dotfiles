{
  withSystem,
  self,
  inputs,
  _inputs,
  ...
}: {
  flake.nixosConfigurations."gen6" = withSystem "x86_64-linux" (
    {
      pkgs,
      system,
      ...
    }:
      self.lib.mkSystem {
        inherit system pkgs;
        specialArgs = {
          inherit self;
          inputs = _inputs;
          packages = self.lib.mkPackages _inputs system;
          flakePath = "/home/ayats/Documents/dotfiles";
        };
        nixosModules = with self.nixosModules; [
          ./configuration.nix
          desktop
          xdg-ninja

          virt
          docker
          # podman
          printing
          ld
          inputs.vscode-server.nixosModules.default
          {
            services.vscode-server = {
              enable = true;
              path = "~/.local/share/code-server/.vscode-server";
            };
          }
          flatpak

          ./fix-bluetooth.nix
          inputs.nix-gaming.nixosModules.pipewireLowLatency
          {
            services.pipewire.lowLatency.enable = true;
          }

          hardware-nvidia
        ];
        homeModules = with self.homeModules; [
          ./home.nix
          common
          xdg-ninja
          gui
          nh
          flatpak
        ];
        specialisations = [
          (self.lib.joinSpecialisations (with self.specialisations; [
            kde
            ayats
            default
          ]))
          # (self.lib.joinSpecialisations (with self.specialisations; [
          #   kde-wayland
          #   ayats
          #   default
          # ]))
          # (self.lib.joinSpecialisations (with self.specialisations; [
          #   hyprland
          #   ayats
          # ]))
          # (self.lib.joinSpecialisations (with self.specialisations; [
          #   gnome
          #   ayats
          #   default
          # ]))
          # (self.lib.joinSpecialisations (with self.specialisations; [
          #   sway
          #   soch
          # ]))
        ];
      }
  );
}
