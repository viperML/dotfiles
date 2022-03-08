{
  config,
  pkgs,
  lib,
  ...
}: let
  xontribs = with pkgs.python3.pkgs; {
    fzf-widgets = buildPythonPackage rec {
      pname = "xontrib-fzf-widgets";
      version = "0.0.4";
      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-EpeOr9c3HwFdF8tMpUkFNu7crmxqbL1VjUg5wTzNzUk=";
      };
    };
    direnv = buildPythonPackage rec {
      pname = "xonsh-direnv";
      version = "1.5.0";
      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-OLjtGD2lX4Yf3aHrxCWmAbSPZnf8OuVrBu0VFbsna1Y=";
      };
    };
    prompt_starship = buildPythonPackage rec {
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
  };

  xonsh-plugged = pkgs.xonsh.overrideAttrs (prev: {
    propagatedBuildInputs =
      prev.propagatedBuildInputs
      ++ (builtins.attrValues xontribs)
      ++ [
        (pkgs.python3.withPackages
          (p:
            with p; [
              numpy
              requests
            ]))
      ];
  });
in {
  home.packages = [xonsh-plugged pkgs.starship];

  xdg.configFile."xonsh/rc.xsh".text = ''
    # This file is managed by Home-Manager!
    xontrib load ${lib.concatStringsSep " " (builtins.attrNames xontribs)} abbrevs

    ${builtins.readFile ./rc.xsh}
  '';
}
