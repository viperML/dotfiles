{
  packages,
  self,
  inputs,
  ...
} @ args: {
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
  nix.buildMachines = [
    {
      hostName = "gen6";
      sshUser = "ayats";
      system = "x86_64-linux";
      systems = [
        "x86_64-linux"
        "i686-linux"
        "aarch64-linux"
      ];
      supportedFeatures = [
        "kvm"
        "nixos-test"
      ];
      speedFactor = 2;
      maxJobs = 16;
    }
  ];
}
