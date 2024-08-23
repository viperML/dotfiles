{pkgs ? import <nixpkgs> {}}: {
  shell = with pkgs;
    mkShell {
      packages = [
        nodePackages.typescript
        nodePackages.typescript-language-server
        ags
      ];
    };

  agsTypes =
    pkgs.runCommandLocal "ags-types" {
      nativeBuildInputs = [
        pkgs.which
        pkgs.ags
      ];
    } ''
      ags --init --config ./config.js
      ln -vsfT $(realpath ./types) $out
    '';

  inherit pkgs;
}
