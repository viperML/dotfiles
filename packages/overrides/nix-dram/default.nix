{
  nix-dram,
  symlinkJoin,
}:
symlinkJoin {
  inherit (nix-dram) name;
  paths = [nix-dram];
  postBuild = ''
    rm $out/bin/nix-channel
  '';
}
