# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  awesome-wm-widgets = {
    pname = "awesome-wm-widgets";
    version = "c8388f484e72c8eaef2d9562b2dc1ff293518782";
    src = fetchFromGitHub ({
      owner = "streetturtle";
      repo = "awesome-wm-widgets";
      rev = "c8388f484e72c8eaef2d9562b2dc1ff293518782";
      fetchSubmodules = false;
      sha256 = "sha256-1PrrJobHBMtwdZt0v88BQ935uKCK7LPWbehBtaF9fps=";
    });
    date = "2023-03-06";
  };
  bling = {
    pname = "bling";
    version = "401985a327797cf146d95789f83421beeda8a27e";
    src = fetchFromGitHub ({
      owner = "BlingCorp";
      repo = "bling";
      rev = "401985a327797cf146d95789f83421beeda8a27e";
      fetchSubmodules = false;
      sha256 = "sha256-emJz0RuySe4ysIcgFQyABajsH642336asOiVpf3MLqA=";
    });
    date = "2023-05-22";
  };
  freedesktop = {
    pname = "freedesktop";
    version = "c82ad2960c5f0c84e765df68554c266ea7e9464d";
    src = fetchFromGitHub ({
      owner = "lcpz";
      repo = "awesome-freedesktop";
      rev = "c82ad2960c5f0c84e765df68554c266ea7e9464d";
      fetchSubmodules = false;
      sha256 = "sha256-lQstCcTPUYUt5hzAJIyQ16crPngeOnUla7I4QiG6gEs=";
    });
    date = "2022-06-23";
  };
  lain = {
    pname = "lain";
    version = "88f5a8abd2649b348ffec433a24a263b37f122c0";
    src = fetchFromGitHub ({
      owner = "lcpz";
      repo = "lain";
      rev = "88f5a8abd2649b348ffec433a24a263b37f122c0";
      fetchSubmodules = false;
      sha256 = "sha256-MH/aiYfcO3lrcuNbnIu4QHqPq25LwzTprOhEJUJBJ7I=";
    });
    date = "2023-01-12";
  };
  revelation = {
    pname = "revelation";
    version = "d8b58e3776ec0ace45b5bc1160e322b69fa16d6f";
    src = fetchFromGitHub ({
      owner = "guotsuan";
      repo = "awesome-revelation";
      rev = "d8b58e3776ec0ace45b5bc1160e322b69fa16d6f";
      fetchSubmodules = false;
      sha256 = "sha256-YwIQxjKJFgJdCwPs1Vq7JrmmdN3PVxLKofVOiWQZu7Y=";
    });
    date = "2020-08-07";
  };
  sharedtags = {
    pname = "sharedtags";
    version = "47fbce14337600124d49d33eb2476b5ed96a966c";
    src = fetchFromGitHub ({
      owner = "Drauthius";
      repo = "awesome-sharedtags";
      rev = "47fbce14337600124d49d33eb2476b5ed96a966c";
      fetchSubmodules = false;
      sha256 = "sha256-7YqRMiqIOhyorug2ju1XrSB3b+qne6fIpy8RuHbQTZc=";
    });
    date = "2023-01-14";
  };
}
