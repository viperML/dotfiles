{
  description = "My flake";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    flake-utils-plus.url = github:gytis-ivaskevicius/flake-utils-plus;
  };

  outputs =
    inputs @
    { self
    , nixpkgs
    , flake-utils-plus
    , ...
    }:
      flake-utils-plus.lib.mkFlake {
        inherit self inputs;

        outputsBuilder = (
          channels: {
            devShell = channels.nixpkgs.mkShell {
              name = "my-shell";

              buildInputs =
                with channels.nixpkgs; [
                  # My build inputs:
                  hello
                  # ---
                ];
            };
          }
        );
      };
}
