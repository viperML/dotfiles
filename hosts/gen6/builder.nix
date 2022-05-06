{...}: {
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
  nix.buildMachines = [
    {
      hostName = "gen6";
      sshUser = "builder";
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
      speedFactor = 1;
      maxJobs = 16;
    }
  ];
  users.users."builder" = {
    isSystemUser = true;
    openssh.authorizedKeys.keys = [
    ];
  };
}
