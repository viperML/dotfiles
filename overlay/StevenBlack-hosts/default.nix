{ stdenv, fetchFromGitHub, python310, writeTextFile, lib }:

stdenv.mkDerivation rec {
  pname = "stevenblack-hosts";
  version = "unstable-2022-01-25";

  src = fetchFromGitHub {
    owner = "StevenBlack";
    repo = "hosts";
    rev = "c85f1986ffb5954a3b6d0368488f53e9059f3c0e";
    sha256 = "0rcbzhhhyckxs5ypm9hhc3cl006jdwfzmc91xixwfqzilx5qqazs";
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
