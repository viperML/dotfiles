{
  dockerTools,
  neovim,
  fish,
  git,
  eza,
  coreutils,
  fakeNss,
}:
dockerTools.streamLayeredImage {
  name = "hpc-env";
  contents = [
    fakeNss
    neovim
    fish
    git
    coreutils
    eza
    dockerTools.usrBinEnv
    dockerTools.binSh
  ];
  extraCommands = ''
    mkdir -m 1777 tmp
  '';
  config = {
    Cmd = [ "/bin/fish" ];
    WorkingDir = "/work";
    Env = [
      "HOME=/work"
    ];
  };
}
