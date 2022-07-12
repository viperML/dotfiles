{...}: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
  };

  programs.sway = {
    enable = true;
    extraOptions = ["--unsupported-gpu"];
    wrapperFeatures = {
      gtk = true;
    };
  };
}
