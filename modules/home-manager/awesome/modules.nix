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
    rev = "1117422e8a0e338fca179e203d47077819410a7b";
    sha256 = "0viv4dzzwsb3cpxhsa4qkzvz0wd0py4kmmj7s8h3ch3b8dmn3b9z";
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
    rev = "4933d6cb27390776a21c659020d8ba1f4a027624";
    sha256 = "0g42klv9052j4cvc6pi68ynf340a5vxgxvzn1qr9w6hfly0frx9l";
  };
  bling = fetchFromGitHub {
    repo = "bling";
    owner = "BlingCorp";
    rev = "4d88068dda380b4fd0c8fd883530d7b31b8c9d2d";
    sha256 = "1yw0n0qmxs1w9ramsm2riizgc4cq213n9hswj280h8v8kmqjfan4";
  };
}
