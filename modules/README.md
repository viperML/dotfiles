# modules

* [home-manager](./home-manager): modules to be used with home-manager

* [nixos](./nixos): modules to be used with NixOS

* [misc](./misc): configurations not managed by nix

Design considerations:

* Try to be as username-agnostic as possible (`mainUser` used when not possible)

* Try to not hardcode the path to this flake

* Import to enable, remove to restore the state. The modules won't export options that have to be enabled.
