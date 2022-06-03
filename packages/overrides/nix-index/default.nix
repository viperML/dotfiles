{
  stdenv,
  symlinkJoin,
  nix-index-unwrapped,
  makeWrapper,
  runCommandNoCC,
}: let
  lock = builtins.fromJSON (builtins.readFile ./lock.json);

  db = with lock;
    builtins.fetchurl {
      url = "https://github.com/Mic92/nix-index-database/releases/download/${tagName}/index-x86_64-linux";
      inherit sha256;
    };

  path = runCommandNoCC "nix-index-db" {inherit db;} ''
    mkdir -p $out
    cp $db $out/files
  '';

  inherit (nix-index-unwrapped) src;
in
  symlinkJoin {
    inherit (nix-index-unwrapped) name;
    paths = [nix-index-unwrapped];
    buildInputs = [makeWrapper];
    postBuild = ''
      cp -f ${src}/command-not-found.sh $out/etc/profile.d/command-not-found.sh
      substituteInPlace $out/etc/profile.d/command-not-found.sh \
        --replace "@out@" "$out"
      substituteInPlace $out/etc/profile.d/command-not-found.sh \
        --replace '-e "$HOME/.nix-profile/manifest.json"' "true"

      wrapProgram $out/bin/nix-index \
        --add-flags "--db ${path}"
      wrapProgram $out/bin/nix-locate \
        --add-flags "--db ${path}"
    '';
  }
