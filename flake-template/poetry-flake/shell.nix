{
  poetry2nix,
  python3,
}:
(poetry2nix.mkPoetryEnv rec {
  python = python3;

  src = ./.;
  projectDir = src;
})
.env
.overrideAttrs (prev: {
  buildInputs = with pkgs; [
    poetry
  ];
})
