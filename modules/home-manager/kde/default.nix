{ config, pkgs, inputs, lib, ... }:

{
  home.packages = with pkgs; [
    plasma-applet-splitdigitalclock
  ];
}
