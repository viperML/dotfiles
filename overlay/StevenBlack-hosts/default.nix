{ stdenv
, fetchFromGitHub
, python310
, writeTextFile
, lib
}:
stdenv.mkDerivation rec {
  pname = "stevenblack-hosts";
  version = "unstable-2022-02-05";

  src = fetchFromGitHub {
    owner = "StevenBlack";
    repo = "hosts";
    rev = "89c42d1c09b53b8bc139a9477bf575e92f1a4ad0";
    sha256 = "1wz203nlq1s4zsbihjn0synacmg61h4nfmh6l39lk68xlr68njza";
  };

  buildInputs = [
    (python310.withPackages (p: [ p.requests ]))
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

  installPhase = '':'';

  meta =
    with lib;
    {
      description = "Unified hosts file with base extensions";
      homepage = "https://github.com/StevenBlack/hosts";
      license = licenses.mit;
      platforms = platforms.all;
    };
}
