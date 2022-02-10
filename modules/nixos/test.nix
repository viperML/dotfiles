{ config
, pkgs
, ...
}:
{
  environment.systemPackages =
    with pkgs;
    [
      file
    ];
}
