let
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;
  python = pkgs.python39;
  pythonPackages = pkgs.python39Packages;
  myPythonEnv = pkgs.poetry2nix.mkPoetryEnv {
    projectDir = ./.;
    python = python;
    overrides = pkgs.poetry2nix.overrides.withDefaults (
      self: super: {
        typing-extensions = super.typing-extensions.overridePythonAttrs (
          old: {
            buildInputs = (old.buildInputs or [ ]) ++
              lib.optional (lib.versionAtLeast old.version "4.0.0") [ self.flit-core ];
          }
        );
      }
    );
  };
in myPythonEnv.env.overrideAttrs (oldAttrs: {
  buildInputs = [ pythonPackages.poetry ];
})
