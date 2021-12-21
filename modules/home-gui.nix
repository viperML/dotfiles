{ config, pkgs, ... }:
{
  xdg = {
   enable = true;
   mime.enable=true;
  };

  # targets.genericLinux.enable = true;

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
          rev = "db701debef4012bf401c329af59306c156fbbd01";
          sha256 = "1ar8b5k67xhvmhfikpc6wcs28lm6z5jg19l17im9n219wrnv408s";
        })
      ];
    })

  ];
}
