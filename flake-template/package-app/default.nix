{
  stdenv,
  lib,
  hello,
}:
stdenv.mkDerivation {
  pname = "myproject";
  version = "0.0.0";

  src = ./.;

  buildPhase = ''
    cp ${hello}/bin/hello .
  '';

  installPhase = ''
    install -Dm755 hello $out/bin/hello
  '';

  meta = {
    description = "My description";
    homepage = "https://my.homepage";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
