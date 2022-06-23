pkgs: let
  inherit (pkgs) lib;
in {
  addFlags = drv: flags: let
    exe = drv.meta.mainProgram or (lib.getName drv.name);
  in
    (pkgs.symlinkJoin {
      inherit (drv) name;
      paths = [drv];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/${exe} \
          --add-flags "${lib.concatStringsSep " " flags}"

        for f in $out/share/applications/*; do
          echo "=> Fixing $f"
          sed -i "s:/nix/store/.*/bin/.* :$out/bin/${exe} :" $f
          sed -i "s:/nix/store/.*/bin/[a-zA-Z-]*$:$out/bin/${exe}:" $f
        done
      '';
    })
    .overrideAttrs (prev: {
      __nocachix = true;
      pname = drv.pname or (lib.getName drv.name);
      version = drv.version or (lib.getVersion drv.name);
      # TODO if I pass a unfree package, the license blocks the evaluation
      # inherit (drv) meta;
    });
}
