{
  pname,
  src,
  date,
  #
  stdenv,
  buildPythonPackage,
  lib,
}:
buildPythonPackage rec {
  inherit pname src;
  version = date;

  propagatedBuildInputs = [
    stdenv.cc
  ];

  meta = with lib; {
    description = "Tool to determine what GCC flags -march=native would resolve into";
    inherit (src.meta) homepage;
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
