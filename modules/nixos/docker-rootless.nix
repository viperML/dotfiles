{
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
    daemon.settings = {
      registry-mirrors = [
        "https://mirror.gcr.io"
      ];
    };
  };
}
