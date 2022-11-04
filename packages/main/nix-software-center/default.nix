{
  callPackage,
  src,
  version,
  pname,
  symlinkJoin,
}: let
  result = callPackage src {};
in
  symlinkJoin {
    name = "${pname}-${version}";
    inherit pname version;
    paths = [result];
    __nocachix = true;
  }
