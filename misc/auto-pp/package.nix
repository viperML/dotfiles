{
  buildGoModule,
  nix-gitignore,
}:
buildGoModule {
  pname = "auto-pp";
  version = "0.1.0";
  vendorHash = "sha256-Ac63bZlBvCrhS7b8mk7aJdApI8UGtJxnZG35L37roGY=";
  src = nix-gitignore.gitignoreSource [ ] ./.;
  meta.mainProgram = "auto-pp";
}
