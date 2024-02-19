{ self
, lib
, ...
}:
let
  pkgs = self.legacyPackages."x86_64-linux";
in
{
  flake.bundlers."x86_64-linux" = {
    id = drv: drv;
    addFlags =
      { drv
      , flags
      ,
      }:
      let
        exe = drv.meta.mainProgram or (lib.getName drv.name);
      in
      (pkgs.symlinkJoin {
        inherit (drv) name;
        pname = drv.pname or (lib.getName drv.name);
        version = drv.version or (lib.getVersion drv.name);
        paths = [ drv ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/${exe} \
            --add-flags "${lib.concatStringsSep " " flags}"

          for f in $out/share/applications/*; do
            echo "=> Fixing $f"
            sed -i "s:/nix/store/.*/bin/.* :$out/bin/${exe} :" $f
            sed -i "s:/nix/store/.*/bin/[a-zA-Z-]*$:$out/bin/${exe}:" $f
          done
        '';
      });
  };
}
