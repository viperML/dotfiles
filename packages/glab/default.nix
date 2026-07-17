# https://gitlab.com/gitlab-org/cli/-/merge_requests/3050

{
  glab,
  callPackages,
  lib,
  easy-secret,
  writeShellApplication,
}:
let
  nv = (callPackages ./_sources/generated.nix { }).glab;
  glab-easy-secret = writeShellApplication {
    name = "easy-secret";
    runtimeInputs = [
      easy-secret
    ];
    text = builtins.readFile ./glab-easy-secret.sh;
    bashOptions = [ ];
  };
in
glab.overrideAttrs (old: {
  version = nv.date;
  src = nv.src;
  postPatch = (old.postUnpack or "") + ''
    echo ${nv.src.rev} > COMMIT
  '';

  postInstall = ''
    ln -vsfT ${lib.getExe glab-easy-secret} $out/bin/glab-easy-secret
  '';

  vendorHash = "sha256-J4HkIoKjBYu8R9EZ7lhMbxs7sJrZlPePWasTTemlMWs=";
})
