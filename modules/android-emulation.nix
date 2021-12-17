{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ genymotion ];
}
