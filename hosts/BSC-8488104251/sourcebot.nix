{
  virtualisation.oci-containers.containers.sourcebot = {
    image = "ghcr.io/sourcebot-dev/sourcebot:latest";
    ports = [
      "3000:3000/tcp"
    ];
    volumes = [
      "sourcebot:/data"
      "${./config.json}:/data/config.json:ro"
      # "/x/src/dotfiles/hosts/BSC-8488104251/config.json:/data/config.json"
    ];
    environment = {
      CONFIG_PATH = "/data/config.json";
    };
    environmentFiles = [
      ./secret.env
    ];
    autoStart = false;
  };
}
