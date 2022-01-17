{ stdenv, fetchFromGitHub, python310, writeTextFile, lib }:

stdenv.mkDerivation rec {
  pname = "stevenblack-hosts";
  version = "3.9.36";

  src = fetchFromGitHub {
    owner = "StevenBlack";
    repo = "hosts";
    rev = "76dde75bc46e944471fa02c6fdc6e09fbb8e2702";
    sha256 = "0n1jykh6ycd9ajpb6j33p1iq8snfnf5kqs55v7g18bwpaz509gi4";
  };

  buildInputs = [
    (python310.withPackages (p: [p.requests]))
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

  meta = with lib; {
    description = "Unified hosts file with base extensions";
    homepage = "https://github.com/StevenBlack/hosts";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
