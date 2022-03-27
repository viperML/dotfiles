{
  stdenv,
  fetchFromGitHub,
  python3,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "stevenblack-hosts";
  version = "unstable-2022-03-24";

  src = fetchFromGitHub {
    owner = "StevenBlack";
    repo = "hosts";
    rev = "4742ba369e5fba0f41db3422c5e6e3f9fe68acbf";
    sha256 = "0pr31c0a438965d11b1ny64lcw8qn6gkwrhpl3frym4cqwnw6gkp";
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
