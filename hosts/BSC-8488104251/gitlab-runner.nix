{ lib, ... }:
{
  services.gitlab-runner = {
    enable = true;

    services = {
      bsc = {
        registrationConfigFile = "/var/lib/secrets/gitlab-bsc";
        dockerImage = "ubuntu:latest";
        tagList = [ "self" ];
        registrationFlags = [
          "--docker-pull-policy"
          "if-not-present"
          "--docker-allowed-pull-policies"
          "if-not-present"
        ];
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
