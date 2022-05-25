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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIBZkBer8ozZ/6u7AQ1FHXiF1MbetEUKZoV5xN5YkhMo ayatsfer@gmail.com"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCsOfG1p2OqNLAjdKBzEjF5ryvXzQDbQeZoqRndgTNKAFx4KGmK0QHB+bUa/ncqtQ3iHaf2+8jpy1XGXwmldkmVV3EXjs/wIgaUFZgJIqHsKlkJOB8GfYy7DaMqmEbhRYUYotKmH4OdnbH8JY2x+baaq706dnVq148wTTZ+sQpi2QMPt2yq1JbrM/1BRClm5cKBGW4VxImeGGSvavDcol3d+ZJJ8t66AgQCC8YTnEhpMTVFCc+7tgtMlD3cbjWnkH6i9vfWOeLITjgQWQAKShH6KFHCoHun14j535Pet2ReBCvRtyuP2vGDRH0kiet6j5ttjUylCJcjzXMTjbo1be0dv8fEyFHSKfKYH+aPX/KvY+5fAgHKWM6fqWgVeF6WW7uFHoxtu58S38bvGvcWWdLN4xeaSmqfZPyPt9udSxD9ZzizApHU584PScoo8AchU3VdMCBESLpXbmzQPy3H5W6ZWATZMLhs0gRpAoyDbzZUtYPKAmWQjioZV+zPszIz+Z6cH1ykxFJQvv4R2ZXTC8pFWBqdURss6dsAzgZs6zylmyhDE9TWIlePgyEoXjkGBKmCAcA+xvDUfzaO1ndiALO/9QJIrqLmGBpdB7o4yTBDMwvyQWnr1maTv6XbC2hSaayJUjlYmRAUaDZM90A/vwf6R6sxuoPX7nFvOvQqpZYCTw== ayats@viperSL4"
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
