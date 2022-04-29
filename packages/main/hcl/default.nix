{
  buildGoModule,
  fetchFromGitHub,
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
}
