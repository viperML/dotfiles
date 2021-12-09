{ config, pkgs, ... }:
{
  home.packages = with pkgs;
  let
    xonsh-direnv = pkgs.python3Packages.buildPythonPackage {
      name = "xonsh-direnv";
      src = fetchFromGitHub {
        owner = "74th";
        repo = "xonsh-direnv";
        rev = "85c9a378599ab560cf2d41b8a5c1f15a233aa228";
        sha256 = "1hr43g5blyqpc9xvd3v27s48bqc8mnc0vxficqfcghbqmi5jhfvb";
      };
    };
  in [
    xonsh
    xonsh-direnv
  ];

  home.file.".xonshrc".source = ./xonshrc;
}
