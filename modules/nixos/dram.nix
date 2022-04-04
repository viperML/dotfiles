{packages, ...}: {
  nix = {
    package = packages.nix-dram.nix-dram;
    extraOptions = "default-flake = self";
  };
}
