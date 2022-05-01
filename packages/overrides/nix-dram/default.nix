{
  nix-dram,
  symlinkJoin,
}:
symlinkJoin {
  inherit (nix-dram) name meta;
  paths = [nix-dram];
  postBuild = ''
    rm $out/bin/nix-channel
  '';
}
