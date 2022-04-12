{packages, ...}: {
  nix = {
    package = packages.self.nix-dram;
    extraOptions = "default-flake = self";
  };
}
