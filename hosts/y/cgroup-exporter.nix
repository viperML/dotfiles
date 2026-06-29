{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  name = "cgroup-exporter";
  src = fetchFromGitHub {
    owner = "arianvp";
    repo = "cgroup-exporter";
    rev = "v0.3.3";
    hash = "sha256-lv9Ox8SLAbru9CEIQLB9DahUq3iMPO+rtzy08Y3365s=";
  };
  env.CGO_ENABLED = 0;
  vendorHash = "sha256-PzUdwc04criIThlCDoQKR9N3xBkRSc3UpEGwyBHIlYI=";
  meta.mainProgram = "cgroup-exporter";
}
