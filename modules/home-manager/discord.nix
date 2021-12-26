{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    (discord-plugged.override {
      plugins = with pkgs; [
        (fetchFromGitHub {
          owner = "notsapinho";
          repo = "powercord-together";
          rev = "0bbd1ff85348852be8b6478d150af8729d35b08e";
          sha256 = "0cl93wn5yxsw7vj1z4nz823rk2b2ymfrrmbl36kgbbvs76c6wwg1";
        })

        (fetchFromGitHub {
          owner = "davidcralph";
          repo = "kaomoji";
          rev = "817cadb1a4d224ea5580a8223ac1dfe3e3262ba9";
          sha256 = "0izj83r10idqwwa8dz04gfjcjn4yp2lhvzvakyfnikrp5a0dn9bf";
        })
      ];

      themes = with pkgs; [
        (fetchFromGitHub {
          owner = "LuckFire";
          repo = "amoled-cord";
          rev = "d008cdab7ca89212016901d3e9f939470c2e2fa7";
          sha256 = "0sb8d9jnqc0qqsf86jbxj51b445ln6080dvdndq8qk8pgd9fd3k6";
        })
      ];
    })
  ];
}
