{
  stdenv,
  fetchFromGitHub,
  python3,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "stevenblack-hosts";
  version = "unstable-2022-02-13";

  src = fetchFromGitHub {
    owner = "StevenBlack";
    repo = "hosts";
    rev = "824cd374f25425ef3927dadb8b083602b29a8d9e";
    sha256 = "15khwg38p8xiv5v982s8r0irx5x02dm1xji4k7wwmq9r9f80k184";
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

  meta =
    with lib; {
      description = "Unified hosts file with base extensions";
      homepage = "https://github.com/StevenBlack/hosts";
      license = licenses.mit;
      platforms = platforms.all;
    };
}
