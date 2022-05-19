{
  packages,
  self,
  inputs,
  ...
} @ args: {
  programs.ssh.extraConfig = ''
    Host gen6
        HostName gen6.ayatsfer.gmail.com.beta.tailscale.net
  '';
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
  nix.buildMachines = [
    {
      hostName = "gen6.ayatsfer.gmail.com.beta.tailscale.net";
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

  systemd.services."nix-daemon" = {
    environment.SSH_AUTH_SOCK = "/run/user/1000/ssh-agent";
  };
}
