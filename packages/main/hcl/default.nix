{
  pname,
  version,
  src,
  #
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule {
  inherit pname version src;

  vendorSha256 = "sha256-Wa0tDgHgSPVY6GNxCv9mGWSSi/NuwZq1VO+jwUCMvNI=";

  meta = with lib; {
    description = "HashiCorp configuration language";
    inherit (src.meta) homepage;
    license = licenses.mpl20;
    platforms = platforms.all;
  };
}
