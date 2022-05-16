{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "hcl";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "hcl";
    rev = "v${version}";
    sha256 = "sha256-tL0jkddKmfQu3a4BDw/RCwQqhRrPf9XWXHl/nG09yVc=";
  };

  vendorSha256 = "sha256-Wa0tDgHgSPVY6GNxCv9mGWSSi/NuwZq1VO+jwUCMvNI=";

  meta = with lib; {
    description = "HashiCorp configuration language";
    inherit (src.meta) homepage;
    license = licenses.mpl20;
    platforms = platforms.linux;
  };
}
