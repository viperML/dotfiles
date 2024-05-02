{
  symlinkJoin,
  nix-index-unwrapped,
  runCommandLocal,
  fzf,
  database,
  databaseDate,
  makeWrapper,
}: let
  # Add a folder in between and set name to `file`
  database' = runCommandLocal "nix-index-database" {} ''
    mkdir -p $out
    ln -s ${database} $out/files
  '';
  inherit (nix-index-unwrapped) pname;
  version = "${nix-index-unwrapped.version}+db=${databaseDate}";
in
  symlinkJoin {
    name = "${pname}-${version}";
    inherit pname version;
    paths = [nix-index-unwrapped];
    buildInputs = [makeWrapper];
    # Install broken, command-not-found is not detected by fish by using the vendor functions
    postBuild = ''
      cp -fv ${./command-not-found.sh} $out/etc/profile.d/command-not-found.sh
      substituteInPlace $out/etc/profile.d/command-not-found.sh \
        --replace "nix-locate" "$out/bin/nix-locate" \
        --replace "fzf" "${fzf}/bin/fzf"

      mkdir -p $out/share/fish/vendor_functions.d
      cp -v ${./command-not-found.fish} $out/share/fish/vendor_functions.d/nix-index.fish
      substituteInPlace $out/share/fish/vendor_functions.d/nix-index.fish \
        --replace "nix-locate" "$out/bin/nix-locate" \
        --replace "fzf" "${fzf}/bin/fzf"

      wrapProgram $out/bin/nix-index \
        --add-flags "--db ${database'}"
      wrapProgram $out/bin/nix-locate \
        --add-flags "--db ${database'}"
    '';
  }
