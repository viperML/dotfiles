{ wlroots
, fetchFromGitHub
}:
asd wlroots.overrideAttrs (
  prev: {
    src = fetchFromGithub {
      repo = "wlroots-eglstreams";
      owner = "danvd";
      rev = "5bde12a6dbf4020d8aa0e0a743cb4f502af07891";
      sha256 = "5bde12a6dbf4020d8aa0e0a743cb4f502af07891";
    };
  }
)
