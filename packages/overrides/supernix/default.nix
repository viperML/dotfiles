{
  sources,
  #
  nix,
  git,
  runCommand,
  patchutils
}: let
  nix-5567-patch =
    runCommand "nix-5567-patch" {
      nativeBuildInputs = [git];
    } ''
      set -x
      git diff --no-index ${sources.Minion3665-nix-original.src} ${sources.Minion3665-nix-patched.src} \
        | grep -v '^diff\|^index' \
        | sed 's#/nix/store/.[^/]*/#/#' \
        > $out || true
      set +x
    '';
in
  nix.overrideAttrs (old: {
    __nocachix = true;
    pname = "supernix";
    patches =
      (old.patches or [])
      ++ [
        nix-5567-patch
        ./nix-flake-default.patch
      ];
    meta =
      old.meta
      // {
        mainProgram = "nix";
      };
  })
