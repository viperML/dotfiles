{
  config,
  pkgs,
  ...
}:
{
  home.packages = [pkgs.foot];

  xdg.configFile."foot/foot.ini".text = ''
    shell=fish
    font=VictorMono Nerd Font:size=10
    pad=10x10
  '';
}
