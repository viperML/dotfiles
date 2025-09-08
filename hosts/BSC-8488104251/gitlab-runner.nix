{ lib, ... }:
{
  services.gitlab-runner = {
    enable = true;

    services = {
      bsc = {
        registrationConfigFile = "/var/lib/secrets/gitlab-bsc";
        dockerImage = "ubuntu:latest";
        tagList = [ "self" ];
      };
    };
  };

  systemd.services.gitlab-runner = {
    wantedBy = lib.mkForce [ ];
    serviceConfig = {
      DynamicUser = lib.mkForce false;
    };
  };
}
