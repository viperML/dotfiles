{
  stdenv,
  autoPatchelfHook,
  fetchzip,
}:
stdenv.mkDerivation (final: {
  pname = "opencode";
  version = "0.1.126";
  src = fetchzip {
    url = "https://github.com/sst/opencode/releases/download/v${final.version}/opencode-linux-x64.zip";
    hash = "sha256-bTgbVirtHWiVS2mG6sC/+6X35Yv5B21nTF/L+87u7wo=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  installPhase = ''
    install -Dm555 ./opencode $out/bin/opencode
  '';

  # SOmehow falls back to the bundled bun when stripping
  dontStrip = true;
})