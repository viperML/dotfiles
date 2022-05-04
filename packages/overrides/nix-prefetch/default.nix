{
  nix-prefetch,
  fetchFromGitHub,
  nix,
  symlinkJoin,
  makeWrapper,
}: let
  nix-prefetch' =
    (nix-prefetch.override {
      inherit nix;
    })
    .overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "ShamrockLee";
        repo = "nix-prefetch";
        rev = "9da16d679c67dd80d9c3a2719790045151c3de2f";
        sha256 = "sha256-Ve2/yvT0Pb/hIxGUjVyxrGQaNQCMNRUgsGYIjEjfb+c=";
      };
    });
in
  symlinkJoin {
    inherit (nix-prefetch') name meta;
    paths = [nix-prefetch'];
    buildInputs = [makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/nix-prefetch \
        --set NIX_PATH "nixpkgs=/etc/nix/inputs/nixpkgs"
    '';
  }
