{
  config,
  pkgs,
  inputs,
  packages,
  ...
}: let
  name = "ayats";
  home = "/home/ayats";
in {
  users.mutableUsers = false;

  users.users.ayats = {
    inherit name home;
    createHome = true;
    description = "Fernando Ayats";
    isNormalUser = true;
    extraGroups = [
      "audio"
      "input"
      "networkmanager"
      "systemd-journal"
      "uucp"
      "video"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
    ];
  };

  security.sudo.extraRules = [
    {
      groups = ["wheel"];
      commands = [
        {
          command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
          options = ["SETENV" "NOPASSWD"];
        }
        {
          command = "${packages.self.nh}/bin/nh";
          options = ["SETENV" "NOPASSWD"];
        }
      ];
    }
  ];

  services.xserver.displayManager.autoLogin.user = name;
  services.getty.autologinUser = name;

  nix.settings.trusted-users = ["ayats"];
}
