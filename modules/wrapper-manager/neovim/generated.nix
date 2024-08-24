# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  bufferline-nvim = {
    pname = "bufferline-nvim";
    version = "v4.7.0";
    src = fetchFromGitHub {
      owner = "akinsho";
      repo = "bufferline.nvim";
      rev = "v4.7.0";
      fetchSubmodules = false;
      sha256 = "sha256-QWZB3C9XFVBRurUfYj0orr6LLP7eI6vYhkKsrdG+wZI=";
    };
  };
  cmp-async-path = {
    pname = "cmp-async-path";
    version = "838a12586642940fde05f0b4bae0d38d8fbc5702";
    src = fetchgit {
      url = "https://codeberg.org/FelipeLema/cmp-async-path";
      rev = "838a12586642940fde05f0b4bae0d38d8fbc5702";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-5hNJYCfZdHNJEky2bF+aXZc+ERnc63n3uAAOgqePHnA=";
    };
    date = "2024-08-22";
  };
  cmp-cmdline = {
    pname = "cmp-cmdline";
    version = "d250c63aa13ead745e3a40f61fdd3470efde3923";
    src = fetchFromGitHub {
      owner = "hrsh7th";
      repo = "cmp-cmdline";
      rev = "d250c63aa13ead745e3a40f61fdd3470efde3923";
      fetchSubmodules = false;
      sha256 = "sha256-iBmXp+gUSMbgfkv7c7RDQAwPq02e07wEnBETP0dWBOo=";
    };
    date = "2024-03-22";
  };
  cmp-nvim-lsp = {
    pname = "cmp-nvim-lsp";
    version = "39e2eda76828d88b773cc27a3f61d2ad782c922d";
    src = fetchFromGitHub {
      owner = "hrsh7th";
      repo = "cmp-nvim-lsp";
      rev = "39e2eda76828d88b773cc27a3f61d2ad782c922d";
      fetchSubmodules = false;
      sha256 = "sha256-CT1+Z4XJBVsl/RqvJeGmyitD6x7So0ylXvvef5jh7I8=";
    };
    date = "2024-05-17";
  };
  conform-nvim = {
    pname = "conform-nvim";
    version = "v7.1.0";
    src = fetchFromGitHub {
      owner = "stevearc";
      repo = "conform.nvim";
      rev = "v7.1.0";
      fetchSubmodules = false;
      sha256 = "sha256-THl44vHBvgdaYXAUl6g1ccR2mYTBBVizgnqT2MbRngw=";
    };
    opt = "true";
  };
  dressing-nvim = {
    pname = "dressing-nvim";
    version = "c5775a888adbc50652cb370073fcfec963eca93e";
    src = fetchFromGitHub {
      owner = "stevearc";
      repo = "dressing.nvim";
      rev = "c5775a888adbc50652cb370073fcfec963eca93e";
      fetchSubmodules = false;
      sha256 = "sha256-6T2p0hI7/WqaDFQodaDq7uiyuplVqeekayQ2equ/mC0=";
    };
    date = "2024-08-16";
  };
  fidget-nvim = {
    pname = "fidget-nvim";
    version = "d855eed8a06531a7e8fd0684889b2943f373c469";
    src = fetchFromGitHub {
      owner = "j-hui";
      repo = "fidget.nvim";
      rev = "d855eed8a06531a7e8fd0684889b2943f373c469";
      fetchSubmodules = false;
      sha256 = "sha256-fjxdRN08BMU7jTWdhdzh8kW18ZURS9SJCwnTxuz6aFE=";
    };
    date = "2024-07-13";
  };
  git-conflict-nvim = {
    pname = "git-conflict-nvim";
    version = "45cde6f0acf26d0e4b64acfa45349dd1da01e577";
    src = fetchFromGitHub {
      owner = "akinsho";
      repo = "git-conflict.nvim";
      rev = "45cde6f0acf26d0e4b64acfa45349dd1da01e577";
      fetchSubmodules = false;
      sha256 = "sha256-SablEni7+VYXUs5lkgpZBqzIBWDE2p3f+R4vXrzF+oE=";
    };
    opt = "true";
    date = "2024-06-26";
  };
  gitsigns-nvim = {
    pname = "gitsigns-nvim";
    version = "v0.9.0";
    src = fetchFromGitHub {
      owner = "lewis6991";
      repo = "gitsigns.nvim";
      rev = "v0.9.0";
      fetchSubmodules = false;
      sha256 = "sha256-AbnjBqKLhOGMGBXBnu9zbL3PG7rKmAoYtxY17kzFEIA=";
    };
    opt = "true";
  };
  indent-blankline-nvim = {
    pname = "indent-blankline-nvim";
    version = "v3.7.2";
    src = fetchFromGitHub {
      owner = "lukas-reineke";
      repo = "indent-blankline.nvim";
      rev = "v3.7.2";
      fetchSubmodules = false;
      sha256 = "sha256-/2PpfXVXFd6adzdizcpCvLftOELuWr3OJja00pr2yG8=";
    };
    opt = "true";
  };
  kaganawa-nvim = {
    pname = "kaganawa-nvim";
    version = "e5f7b8a804360f0a48e40d0083a97193ee4fcc87";
    src = fetchFromGitHub {
      owner = "rebelot";
      repo = "kanagawa.nvim";
      rev = "e5f7b8a804360f0a48e40d0083a97193ee4fcc87";
      fetchSubmodules = false;
      sha256 = "sha256-FnwqqF/jtCgfmjIIR70xx8kL5oAqonrbDEGNw0sixoA=";
    };
    date = "2024-07-03";
  };
  lualine-nvim = {
    pname = "lualine-nvim";
    version = "b431d228b7bbcdaea818bdc3e25b8cdbe861f056";
    src = fetchFromGitHub {
      owner = "nvim-lualine";
      repo = "lualine.nvim";
      rev = "b431d228b7bbcdaea818bdc3e25b8cdbe861f056";
      fetchSubmodules = false;
      sha256 = "sha256-gCm7m96PkZyrgjmt7Efc+NMZKStAq1zr7JRCYOgGDuE=";
    };
    date = "2024-08-12";
  };
  lz-n = {
    pname = "lz-n";
    version = "v2.2.0";
    src = fetchFromGitHub {
      owner = "nvim-neorocks";
      repo = "lz.n";
      rev = "v2.2.0";
      fetchSubmodules = false;
      sha256 = "sha256-RCcdPudg2lS4vgoJ3SlE4aJe9hJ+F7uFrPKNcqXB55s=";
    };
  };
  neo-tree-nvim = {
    pname = "neo-tree-nvim";
    version = "206241e451c12f78969ff5ae53af45616ffc9b72";
    src = fetchFromGitHub {
      owner = "nvim-neo-tree";
      repo = "neo-tree.nvim";
      rev = "206241e451c12f78969ff5ae53af45616ffc9b72";
      fetchSubmodules = false;
      sha256 = "sha256-eNGuQEjAKsPuRDGaw95kCVOmP64ZDnUuFBppqtcrhZ4=";
    };
    opt = "true";
    date = "2024-06-11";
  };
  neovim-session-manager = {
    pname = "neovim-session-manager";
    version = "cbaebd92dce84e9ba63cb07d3199e5a19b204c1a";
    src = fetchFromGitHub {
      owner = "Shatur";
      repo = "neovim-session-manager";
      rev = "cbaebd92dce84e9ba63cb07d3199e5a19b204c1a";
      fetchSubmodules = false;
      sha256 = "sha256-HnNbB5Nx65Zb5oTjED0et+bAAEVX5+8pZxwTZvxRtQ8=";
    };
    opt = "true";
    date = "2024-08-02";
  };
  nui-nvim = {
    pname = "nui-nvim";
    version = "0.3.0";
    src = fetchFromGitHub {
      owner = "MunifTanjim";
      repo = "nui.nvim";
      rev = "0.3.0";
      fetchSubmodules = false;
      sha256 = "sha256-L0ebXtv794357HOAgT17xlEJsmpqIHGqGlYfDB20WTo=";
    };
  };
  nvim-autopairs = {
    pname = "nvim-autopairs";
    version = "19606af7c039271d5aa96bceff101e7523af3136";
    src = fetchFromGitHub {
      owner = "windwp";
      repo = "nvim-autopairs";
      rev = "19606af7c039271d5aa96bceff101e7523af3136";
      fetchSubmodules = false;
      sha256 = "sha256-e+67etOnK98WUVNy/NsMm51X2xLQMjGuQvp765o9PNA=";
    };
    date = "2024-08-19";
  };
  nvim-cmp = {
    pname = "nvim-cmp";
    version = "ae644feb7b67bf1ce4260c231d1d4300b19c6f30";
    src = fetchFromGitHub {
      owner = "hrsh7th";
      repo = "nvim-cmp";
      rev = "ae644feb7b67bf1ce4260c231d1d4300b19c6f30";
      fetchSubmodules = false;
      sha256 = "sha256-NcodgUp8obTsjgc+5j2dKr0f3FelYikQTJngfZXRZzo=";
    };
    date = "2024-08-01";
  };
  nvim-dap = {
    pname = "nvim-dap";
    version = "0.8.0";
    src = fetchFromGitHub {
      owner = "mfussenegger";
      repo = "nvim-dap";
      rev = "0.8.0";
      fetchSubmodules = false;
      sha256 = "sha256-jdNqA2POc2TEspkgbJdxgnczVEJnBBi+nipTXCPQgyM=";
    };
    opt = "true";
  };
  nvim-dap-python = {
    pname = "nvim-dap-python";
    version = "7c427e2bbc72d46ea3c9602bede6465ef61b8c19";
    src = fetchFromGitHub {
      owner = "mfussenegger";
      repo = "nvim-dap-python";
      rev = "7c427e2bbc72d46ea3c9602bede6465ef61b8c19";
      fetchSubmodules = false;
      sha256 = "sha256-OXAMFIi83lEOtKJ6/bkmaus23GKtYeRkx2Wv+Yvb67g=";
    };
    opt = "true";
    date = "2024-08-19";
  };
  nvim-lspconfig = {
    pname = "nvim-lspconfig";
    version = "v0.1.8";
    src = fetchFromGitHub {
      owner = "neovim";
      repo = "nvim-lspconfig";
      rev = "v0.1.8";
      fetchSubmodules = false;
      sha256 = "sha256-foJ7a59N0a3QaBW24PtwbyYDQVlIsFxiatADLO/hQvc=";
    };
  };
  nvim-navic = {
    pname = "nvim-navic";
    version = "8649f694d3e76ee10c19255dece6411c29206a54";
    src = fetchFromGitHub {
      owner = "SmiteshP";
      repo = "nvim-navic";
      rev = "8649f694d3e76ee10c19255dece6411c29206a54";
      fetchSubmodules = false;
      sha256 = "sha256-0p5n/V8Jlj9XyxV/fuMwsbQ7oV5m9H2GqZZEA/njxCQ=";
    };
    date = "2023-11-30";
  };
  nvim-web-devicons = {
    pname = "nvim-web-devicons";
    version = "3722e3d1fb5fe1896a104eb489e8f8651260b520";
    src = fetchFromGitHub {
      owner = "nvim-tree";
      repo = "nvim-web-devicons";
      rev = "3722e3d1fb5fe1896a104eb489e8f8651260b520";
      fetchSubmodules = false;
      sha256 = "sha256-TeWMlfNTA5+tiPq6D2TVWjdfJVr3FOwpqUDU8kfFZ8E=";
    };
    date = "2024-08-04";
  };
  org-bullets-nvim = {
    pname = "org-bullets-nvim";
    version = "7e76e04827ac3fb13fc645a6309ac14203c4ca6a";
    src = fetchFromGitHub {
      owner = "nvim-orgmode";
      repo = "org-bullets.nvim";
      rev = "7e76e04827ac3fb13fc645a6309ac14203c4ca6a";
      fetchSubmodules = false;
      sha256 = "sha256-bxiL88uUa0Zd/HL7RcC/XVhbkgdlFr6MmlQfkpxFybE=";
    };
    opt = "true";
    date = "2024-07-09";
  };
  orgmode = {
    pname = "orgmode";
    version = "0.3.5";
    src = fetchFromGitHub {
      owner = "nvim-orgmode";
      repo = "orgmode";
      rev = "0.3.5";
      fetchSubmodules = false;
      sha256 = "sha256-TUw+BSynn5KWGHZ1Qt3pStyLR+cbANTUJLywVrFV5is=";
    };
    opt = "true";
  };
  plenary-nvim = {
    pname = "plenary-nvim";
    version = "ec289423a1693aeae6cd0d503bac2856af74edaa";
    src = fetchFromGitHub {
      owner = "nvim-lua";
      repo = "plenary.nvim";
      rev = "ec289423a1693aeae6cd0d503bac2856af74edaa";
      fetchSubmodules = false;
      sha256 = "sha256-6Gm+4zZ80quI5iAW6qPAWTq9h1csPWkZFZ9KnFgYRM0=";
    };
    date = "2024-08-19";
  };
  smart-splits-nvim = {
    pname = "smart-splits-nvim";
    version = "v1.5.0";
    src = fetchFromGitHub {
      owner = "mrjones2014";
      repo = "smart-splits.nvim";
      rev = "v1.5.0";
      fetchSubmodules = false;
      sha256 = "sha256-jtgms2AIbKD0nALa/hVXwAOrPBHE+hCVyn/x8RTPdzM=";
    };
    opt = "true";
  };
  telescope-fzf-native-nvim = {
    pname = "telescope-fzf-native-nvim";
    version = "cf48d4dfce44e0b9a2e19a008d6ec6ea6f01a83b";
    src = fetchFromGitHub {
      owner = "nvim-telescope";
      repo = "telescope-fzf-native.nvim";
      rev = "cf48d4dfce44e0b9a2e19a008d6ec6ea6f01a83b";
      fetchSubmodules = false;
      sha256 = "sha256-GEhPf1f0jkEuDlHNuxVko0ChvuF/zoQroLNUlk8N5EA=";
    };
    opt = "true";
    date = "2024-07-02";
  };
  telescope-nvim = {
    pname = "telescope-nvim";
    version = "0.1.8";
    src = fetchFromGitHub {
      owner = "nvim-telescope";
      repo = "telescope.nvim";
      rev = "0.1.8";
      fetchSubmodules = false;
      sha256 = "sha256-e1ulhc4IIvUgpjKQrSqPY4WpXuez6wlxL6Min9U0o5Q=";
    };
    opt = "true";
  };
  vim-better-whitespace = {
    pname = "vim-better-whitespace";
    version = "86a0579b330b133b8181b8e088943e81c26a809e";
    src = fetchFromGitHub {
      owner = "ntpeters";
      repo = "vim-better-whitespace";
      rev = "86a0579b330b133b8181b8e088943e81c26a809e";
      fetchSubmodules = false;
      sha256 = "sha256-muYPVkTXSur2+/3L/bCB2rlwNl98TI+9WGfIANU+4aQ=";
    };
    opt = "true";
    date = "2024-06-12";
  };
  vim-nix = {
    pname = "vim-nix";
    version = "e25cd0f2e5922f1f4d3cd969f92e35a9a327ffb0";
    src = fetchFromGitHub {
      owner = "LnL7";
      repo = "vim-nix";
      rev = "e25cd0f2e5922f1f4d3cd969f92e35a9a327ffb0";
      fetchSubmodules = false;
      sha256 = "sha256-2/9eyU+uUbcKiNcBDdgdxCBp1vNSP51U/0LTHihEYJY=";
    };
    opt = "true";
    date = "2024-02-24";
  };
  which-key-nvim = {
    pname = "which-key-nvim";
    version = "v3.13.2";
    src = fetchFromGitHub {
      owner = "folke";
      repo = "which-key.nvim";
      rev = "v3.13.2";
      fetchSubmodules = false;
      sha256 = "sha256-nv9s4/ax2BoL9IQdk42uN7mxIVFYiTK+1FVvWDKRnGM=";
    };
    opt = "true";
  };
}
