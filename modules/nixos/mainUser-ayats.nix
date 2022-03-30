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
  # change passwords of users

  users.users.mainUser = {
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
    passwordFile = "/secrets/password/ayats";
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
          command = "${packages.nh.nh}/bin/nh";
          options = ["SETENV" "NOPASSWD"];
        }
      ];
    }
  ];

  security.sudo.wheelNeedsPassword = false;
}
