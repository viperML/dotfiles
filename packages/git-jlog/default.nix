{
  buildGoModule,
  callPackages,
}:
let
  nv = (callPackages ./_sources/generated.nix { }).git-jlog;
in
buildGoModule {
  inherit (nv) pname src;
  version = nv.date;
  vendorHash = "sha256-uYijdxSwEtiMRP4j5H9LXns0qFPoLEvSaPAeXtHIZW4=";
}
