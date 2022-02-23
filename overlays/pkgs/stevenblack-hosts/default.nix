{
  stdenv,
  fetchFromGitHub,
  python3,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "stevenblack-hosts";
  version = "unstable-2022-02-22";

  src = fetchFromGitHub {
    owner = "StevenBlack";
    repo = "hosts";
    rev = "00fcd37e13e62856574f45738276ef9a15fd265d";
    sha256 = "02400sdcih3vnf6wwixd69hhb1ash5cd3ya2ssvxv6qid75r3b8l";
  };

  buildInputs = [
    (python3.withPackages (p: [p.requests]))
  ];

  # Move source into $out because the script opens source files as r/w
  buildPhase = ''
    mkdir -p $out
    cd $out
    cp $src/updateHostsFile.py $out
    cp -r --no-preserve=mode $src/extensions $out
    python $out/updateHostsFile.py --auto --output $out --skipstatichosts --nogendata --minimise --noupdate --extensions fakenews gambling
    rm -rf $out/updateHostsFile.py
    rm -rf $out/extensions
  '';

  dontInstall = true;

  meta = with lib; {
    description = "Unified hosts file with base extensions";
    homepage = "https://github.com/StevenBlack/hosts";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
