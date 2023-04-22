{lib, ...}: {
  imports = [
    ./wayland-compositors.nix
  ];

  system.nixos.label = lib.mkAfter "sway";

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = [];
    extraSessionCommands = ''
      source /etc/profile
      export _SSH_AUTH_SOCK=/run/user/1000/ssh-agent
    '';
  };

  xdg.portal.enable = true;
}
