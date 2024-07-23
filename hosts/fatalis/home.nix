{
  pkgs,
  self',
  config,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  unsafeFlakePath = "/home/ayats/Documents/dotfiles";

  home.packages = [
    self'.packages.vscode
    self'.packages.wezterm
    pkgs.d-spy
    pkgs.age
    pkgs.sops
    pkgs.google-chrome
    pkgs.mesonlsp
    self'.packages.ungoogled-chromium
  ];

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ./private.yaml;
    secrets.ssh_config = {
      sopsFile = ../../misc/private/ssh.yaml;
      path = "${config.home.homeDirectory}/.ssh/config-generic";
    };
  };

  home.activation.ssh_config = config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -pv ~/.ssh
    touch ~/.ssh/config-device
    rm -rf ~/.ssh/config
    echo "## WARNING: THIS FILE WAS AUTOGENERATED" > ~/.ssh/config
    cat ~/.ssh/config-device >> ~/.ssh/config
    cat ~/.ssh/config-generic >> ~/.ssh/config
  '';
}
