# modules

* [home-manager](./home-manager): modules to be used with home-manager

* [nixos](./nixos): modules to be used with NixOS

Design considerations:

* Import to enable, remove to restore the state. The modules won't export options that have to be enabled.

* Any hardcoded paths and usernames have been removed, except in `mainUser-` files. Any module should be able to be imported into any NixOS without any prior knowledge.
