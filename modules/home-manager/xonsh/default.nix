{
  config,
  pkgs,
  lib,
  ...
}: let
  my-python = pkgs.python3;
  # xontrib-kitty = with my-python.pkgs;
  #   buildPythonPackage rec {
  #     pname = "xontrib-kitty";
  #     version = "0.0.2";
  #     src = fetchPypi {
  #       inherit pname version;
  #       sha256 = "sha256-MoAylQLdZd9TaKDe7nNYCN4vyqloAoHfCrBRKGPJyro=";
  #     };
  #     doCheck = false;
  #   };
  xontrib-onepath = with my-python.pkgs;
    buildPythonPackage rec {
      pname = "xontrib-onepath";
      version = "0.3.2";
      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-xYLns/RW4L731fxJWXFBGuZL9d0szMdhXSRDhEehIiQ=";
      };
    };
  xonsh-direnv = with my-python.pkgs;
    buildPythonPackage rec {
      pname = "xonsh-direnv";
      version = "1.5.0";
      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-OLjtGD2lX4Yf3aHrxCWmAbSPZnf8OuVrBu0VFbsna1Y=";
      };
    };
  xontrib-prompt-starship = with my-python.pkgs;
    buildPythonPackage rec {
      pname = "xontrib-prompt-starship";
      version = "0.2.0";
      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-rBF/Im849Mih9rupNS2Z1JFwm/gGLHDETdmBkk0G4Mk=";
      };
      patches = [
        ./prompt-starship.patch
      ];
    };

  # my-plugins = with my-python.pkgs; [
  #   (fetchPypi {
  #   })
  # ];
  # xonsh-wrapped = pkgs.symlinkJoin {
  #   name = "xonsh";
  #   paths = [
  #     pkgs.xonsh
  #     xontrib-kitty
  #   ];
  # };
  # xonsh-wrapped = my-python.withPackages (p: [
  #   pkgs.xonsh
  #   xontrib-kitty
  # ]);
  xonsh-plugged = pkgs.xonsh.overrideAttrs (prev: {
    propagatedBuildInputs =
      prev.propagatedBuildInputs
      ++ [
        # xontrib-kitty
        # xontrib-onepath
        xonsh-direnv
        xontrib-prompt-starship
        # my-python.pkgs.numpy
        # my-python.pkgs.matplotlib
      ];
  });
in {
  home.packages = [xonsh-plugged pkgs.starship];

  xdg.configFile."xonsh/rc.xsh".source = ./rc.xsh;
}
