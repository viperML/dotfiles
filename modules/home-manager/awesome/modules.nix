{pkgs}: let
  inherit (pkgs) fetchFromGitHub;
in {
  sharedtags = fetchFromGitHub {
    repo = "awesome-sharedtags";
    owner = "Drauthius";
    rev = "2a4396ea777de75258777948a93389714206bd93";
    sha256 = "08gjjh73l5cjh2sy84lw931cpzcd182i3ck305w7hsll9awwlc31";
  };
  awesome-wm-widgets = fetchFromGitHub {
    repo = "awesome-wm-widgets";
    owner = "streetturtle";
    rev = "b8e3a861f4829b2c3820e9a40294a3d9125fbf23";
    sha256 = "1y3bbxczzrqk1d2636rc0z76x8648vf3f78dwsjwsy289zmby3dq";
  };
  freedesktop = fetchFromGitHub {
    repo = "awesome-freedesktop";
    owner = "lcpz";
    rev = "ac9de0eccd9d604f43c82cb03e77f6fd791640ab";
    sha256 = "1ckhria95fkwgz10fp010333wlzx04wbdl2kz9j4dgqxhfrbam64";
  };
  revelation = fetchFromGitHub {
    repo = "awesome-revelation";
    owner = "guotsuan";
    rev = "d8b58e3776ec0ace45b5bc1160e322b69fa16d6f";
    sha256 = "1dmv35j8jkpml7514mygvmsadf96pdddbv031dfh45l96b3100k3";
  };
  lain = fetchFromGitHub {
    repo = "lain";
    owner = "lcpz";
    rev = "07cf82e3b2cb051e57d8bba9585973fa6e2c659e";
    sha256 = "0lxpw6z55hpd2yzj85jwwim4jbgl1arzf3nqhkkr8sy6ryxq5r6d";
  };
  bling = fetchFromGitHub {
    repo = "bling";
    owner = "BlingCorp";
    rev = "5b3bc36b70a35d590dedde5bfe13de4e516b64ea";
    sha256 = "0l2hy5h0g8kfjxi4rhw1p94ync6hgfr4if2vg7phjpdbb2fn56wk";
  };
}
