{
  src,
  version,
  pname,
  #
  stdenv,
  symlinkJoin,
  nix-index-unwrapped,
  makeWrapper,
  runCommandNoCC,
}: let
  # Add a folder `files` in between
  db = runCommandNoCC "nix-index-db" {original = src;} ''
    mkdir -p $out
    cp $original $out/files
  '';
in
  symlinkJoin {
    name = "${pname}-${version}";
    inherit pname version;
    paths = [nix-index-unwrapped];
    buildInputs = [makeWrapper];
    postBuild = ''
      cp -f ${nix-index-unwrapped.src}/command-not-found.sh $out/etc/profile.d/command-not-found.sh
      substituteInPlace $out/etc/profile.d/command-not-found.sh \
        --replace "@out@" "$out"
      substituteInPlace $out/etc/profile.d/command-not-found.sh \
        --replace '-e "$HOME/.nix-profile/manifest.json"' "true"

      wrapProgram $out/bin/nix-index \
        --add-flags "--db ${db}"
      wrapProgram $out/bin/nix-locate \
        --add-flags "--db ${db}"
    '';
  }
