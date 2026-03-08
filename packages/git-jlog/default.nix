{
  buildGoModule,
  callPackages,
}:
let
  nv = (callPackages ./generated.nix { }).git-jlog;
in
buildGoModule {
  inherit (nv) pname src;
  version = nv.date;
  vendorHash = "sha256-uYijdxSwEtiMRP4j5H9LXns0qFPoLEvSaPAeXtHIZW4=";
}
