{
  stdenv,
  fetchFromGitHub,
  python3,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "stevenblack-hosts";
  version = "unstable-2022-04-13";

  src = fetchFromGitHub {
    owner = "StevenBlack";
    repo = "hosts";
    rev = "d50ae102ca62436d04a2ec00fe71d7ab719bc92b";
    sha256 = "0p5130bgz12yiw869xvxkg5qpy024j0f8m7wkvfw38p7zz8r09cw";
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
