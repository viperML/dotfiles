{
  stdenv,
  fetchFromGitHub,
  python3,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "stevenblack-hosts";
  version = "unstable-2022-02-07";

  src = fetchFromGitHub {
    owner = "StevenBlack";
    repo = "hosts";
    rev = "aebd77a7da0eb10a65979af260b0294832467a94";
    sha256 = "0h8yqxslxhzw8zayqryr9v32vgxb9y8h6pxhgbpr5fqd0hw27xv0";
  };

  buildInputs = [
    (python3.withPackages (p: [ p.requests ]))
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

  meta =
    with lib; {
      description = "Unified hosts file with base extensions";
      homepage = "https://github.com/StevenBlack/hosts";
      license = licenses.mit;
      platforms = platforms.all;
    };
}
