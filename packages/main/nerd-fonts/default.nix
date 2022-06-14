{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "nerd-fonts";
  version = "2.1.0";

  srcs = [
    (builtins.fetchurl rec {
      name = "Symbols-1000-em_Nerd_Font_Complete.ttf";
      url = "https://github.com/ryanoasis/nerd-fonts/blob/v${version}/src/glyphs/${builtins.replaceStrings ["_"] ["%20"] name}?raw=true";
      sha256 = "sha256:1xamn2migcy0vdsvm9ypf7vl2rzkq0z8cz70a7z9dpx4mdffi2kx";
    })
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    for s in $srcs; do
      name="$(basename $s | cut -c 34-)"
      cp "$s" $out/share/fonts/truetype/"$name"
    done
  '';
}
