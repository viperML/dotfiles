{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.steam.enable = true;

  environment.systemPackages =
    with pkgs; [
      steam-run-native
      lutris
      # ryujinx
      # inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
    ];
}
