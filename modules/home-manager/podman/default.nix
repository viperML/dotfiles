{pkgs, ...}: {
  xdg.configFile = {
    "containers/registries.conf".source = ./registries.conf;
    "containers/policy.json".source = ./policy.json;
  };

  home.packages = [
    pkgs.podman
    pkgs.buildah
  ];
}
