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
    version = "e3206e521ce89fe0e97cc8f14e4fc8c131f369e4";
    src = fetchgit {
      url = "https://codeberg.org/FelipeLema/cmp-async-path";
      rev = "e3206e521ce89fe0e97cc8f14e4fc8c131f369e4";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-0dTibTbBITYuD73XvaOrFWJB3VSz19Bb55zUIlhY02Q=";
    };
    date = "2024-10-11";
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
  comment-nvim = {
    pname = "comment-nvim";
    version = "e30b7f2008e52442154b66f7c519bfd2f1e32acb";
    src = fetchFromGitHub {
      owner = "numToStr";
      repo = "Comment.nvim";
      rev = "e30b7f2008e52442154b66f7c519bfd2f1e32acb";
      fetchSubmodules = false;
      sha256 = "sha256-h0kPue5Eqd5aeu4VoLH45pF0DmWWo1d8SnLICSQ63zc=";
    };
    opt = "true";
    date = "2024-06-09";
  };
  conform-nvim = {
    pname = "conform-nvim";
    version = "v8.1.0";
    src = fetchFromGitHub {
      owner = "stevearc";
      repo = "conform.nvim";
      rev = "v8.1.0";
      fetchSubmodules = false;
      sha256 = "sha256-dM7nJi9pAP8OuUswviHzEPXrlR5/fZC/8bhiVnnvhPg=";
    };
    opt = "true";
  };
  dressing-nvim = {
    pname = "dressing-nvim";
    version = "1b7921eecc65af1baf8ac1dc06f0794934cbcfb2";
    src = fetchFromGitHub {
      owner = "stevearc";
      repo = "dressing.nvim";
      rev = "1b7921eecc65af1baf8ac1dc06f0794934cbcfb2";
      fetchSubmodules = false;
      sha256 = "sha256-EtLYhAwoSoHyGiGrHAVYL4/CqcgO4rSbV6otO3V08hM=";
    };
    date = "2024-09-17";
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
    version = "ed1ca6dfd60bf609714f791cfa63aee33aef64ed";
    src = fetchFromGitHub {
      owner = "akinsho";
      repo = "git-conflict.nvim";
      rev = "ed1ca6dfd60bf609714f791cfa63aee33aef64ed";
      fetchSubmodules = false;
      sha256 = "sha256-n4sOIb0bsA2EwR9ASQq4kkzBZh2JValVIIPXZb28y+M=";
    };
    opt = "true";
    date = "2024-09-10";
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
  haskell-tools-nvim = {
    pname = "haskell-tools-nvim";
    version = "v4.2.0";
    src = fetchFromGitHub {
      owner = "mrcjkb";
      repo = "haskell-tools.nvim";
      rev = "v4.2.0";
      fetchSubmodules = false;
      sha256 = "sha256-W7m6AasEvh0853ItXd/fP9wysHnHvhJcJG5X1ZSX1v0=";
    };
  };
  indent-blankline-nvim = {
    pname = "indent-blankline-nvim";
    version = "v3.8.2";
    src = fetchFromGitHub {
      owner = "lukas-reineke";
      repo = "indent-blankline.nvim";
      rev = "v3.8.2";
      fetchSubmodules = false;
      sha256 = "sha256-OKtaibgT9uPQQmddfj7YKgAYc7lz4ne1dbUz9PdRAvA=";
    };
    opt = "true";
  };
  kaganawa-nvim = {
    pname = "kaganawa-nvim";
    version = "f491b0fe68fffbece7030181073dfe51f45cda81";
    src = fetchFromGitHub {
      owner = "rebelot";
      repo = "kanagawa.nvim";
      rev = "f491b0fe68fffbece7030181073dfe51f45cda81";
      fetchSubmodules = false;
      sha256 = "sha256-UuKvWCPP4biV2OP18+OAookRxfpKfjBgm+1KMaf1z30=";
    };
    date = "2024-08-27";
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
    version = "v2.8.1";
    src = fetchFromGitHub {
      owner = "nvim-neorocks";
      repo = "lz.n";
      rev = "v2.8.1";
      fetchSubmodules = false;
      sha256 = "sha256-OFCdZcCnx6gOR1+DqLbdAGzFDT5xOfiNgc+4TxHtn+M=";
    };
  };
  mdx-nvim = {
    pname = "mdx-nvim";
    version = "61b93f6576cb5229020723c7a81f5a01d2667d05";
    src = fetchFromGitHub {
      owner = "davidmh";
      repo = "mdx.nvim";
      rev = "61b93f6576cb5229020723c7a81f5a01d2667d05";
      fetchSubmodules = false;
      sha256 = "sha256-CYcL+s1634UgquwUYp70iAD2xC6r87j6w5jYv90mUAg=";
    };
    date = "2024-02-21";
  };
  neo-tree-nvim = {
    pname = "neo-tree-nvim";
    version = "a77af2e764c5ed4038d27d1c463fa49cd4794e07";
    src = fetchFromGitHub {
      owner = "nvim-neo-tree";
      repo = "neo-tree.nvim";
      rev = "a77af2e764c5ed4038d27d1c463fa49cd4794e07";
      fetchSubmodules = false;
      sha256 = "sha256-Lqt0KJNT9HmpJwZoWChYeVBrDWhscRe8COqVCwgcTwk=";
    };
    opt = "true";
    date = "2024-09-16";
  };
  neovim-session-manager = {
    pname = "neovim-session-manager";
    version = "ce43f2eb2a52492157d7742e5f684b9a42bb3e5c";
    src = fetchFromGitHub {
      owner = "Shatur";
      repo = "neovim-session-manager";
      rev = "ce43f2eb2a52492157d7742e5f684b9a42bb3e5c";
      fetchSubmodules = false;
      sha256 = "sha256-W9jtfVXHC8MQJwdbxakNqhd+xh/auQb3U09XKdN2Wzw=";
    };
    opt = "true";
    date = "2024-10-09";
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
    version = "ee297f215e95a60b01fde33275cc3c820eddeebe";
    src = fetchFromGitHub {
      owner = "windwp";
      repo = "nvim-autopairs";
      rev = "ee297f215e95a60b01fde33275cc3c820eddeebe";
      fetchSubmodules = false;
      sha256 = "sha256-pqYOaEjKUd5YLVWX0Bf/kYT+sBlN1D24rOBuIz2BIqk=";
    };
    date = "2024-10-01";
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
    version = "03fe9592409236b9121c03b66a682dfca15a5cac";
    src = fetchFromGitHub {
      owner = "mfussenegger";
      repo = "nvim-dap-python";
      rev = "03fe9592409236b9121c03b66a682dfca15a5cac";
      fetchSubmodules = false;
      sha256 = "sha256-2dZFpFQ/O6kYGPSQoRnzCgaZ6wKwp15Z6eAAv3O14jQ=";
    };
    opt = "true";
    date = "2024-10-10";
  };
  nvim-lspconfig = {
    pname = "nvim-lspconfig";
    version = "v1.0.0";
    src = fetchFromGitHub {
      owner = "neovim";
      repo = "nvim-lspconfig";
      rev = "v1.0.0";
      fetchSubmodules = false;
      sha256 = "sha256-6xUVOCdc8dKnJg89sV7A3UbfXrBtoLoFzqkxrNBWzGw=";
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
  nvim-treesitter-textobjects = {
    pname = "nvim-treesitter-textobjects";
    version = "0d79d169fcd45a8da464727ac893044728f121d4";
    src = fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = "nvim-treesitter-textobjects";
      rev = "0d79d169fcd45a8da464727ac893044728f121d4";
      fetchSubmodules = false;
      sha256 = "sha256-9zu/RBS7gMUuVmU/ifDc4Q9l+hgNQ3QfEcOptTpvFmI=";
    };
    date = "2024-10-16";
  };
  nvim-ts-autotag = {
    pname = "nvim-ts-autotag";
    version = "e239a560f338be31337e7abc3ee42515daf23f5e";
    src = fetchFromGitHub {
      owner = "windwp";
      repo = "nvim-ts-autotag";
      rev = "e239a560f338be31337e7abc3ee42515daf23f5e";
      fetchSubmodules = false;
      sha256 = "sha256-QEzUKvT+ChYSa9F4zg3Lw+7Sj0JzJem9nh2mWmS8Y+I=";
    };
    date = "2024-08-27";
  };
  nvim-web-devicons = {
    pname = "nvim-web-devicons";
    version = "19d257cf889f79f4022163c3fbb5e08639077bd8";
    src = fetchFromGitHub {
      owner = "nvim-tree";
      repo = "nvim-web-devicons";
      rev = "19d257cf889f79f4022163c3fbb5e08639077bd8";
      fetchSubmodules = false;
      sha256 = "sha256-SUWEOp+QcfHjYaqqr4Zwvh0x91IAJXvrdMkQtuWMlGc=";
    };
    date = "2024-10-11";
  };
  oil-nvim = {
    pname = "oil-nvim";
    version = "v2.12.2";
    src = fetchFromGitHub {
      owner = "stevearc";
      repo = "oil.nvim";
      rev = "v2.12.2";
      fetchSubmodules = false;
      sha256 = "sha256-B/YSQmoq4ksvXmqIgOa2sRrPV/rf5sgJaRWRDYBx5zk=";
    };
    opt = "true";
  };
  org-bullets-nvim = {
    pname = "org-bullets-nvim";
    version = "46ae687e22192fb806b5977d664ec98af9cf74f6";
    src = fetchFromGitHub {
      owner = "nvim-orgmode";
      repo = "org-bullets.nvim";
      rev = "46ae687e22192fb806b5977d664ec98af9cf74f6";
      fetchSubmodules = false;
      sha256 = "sha256-cRcO0TDY0v9c/H5vQ1v96WiEkIhJDZkPcw+P58XNL9w=";
    };
    opt = "true";
    date = "2024-09-02";
  };
  orgmode = {
    pname = "orgmode";
    version = "0.3.7";
    src = fetchFromGitHub {
      owner = "nvim-orgmode";
      repo = "orgmode";
      rev = "0.3.7";
      fetchSubmodules = false;
      sha256 = "sha256-JfkThMTKEA3D1rB1PsuNByCWO5uDT09lDnnu6SPcZlA=";
    };
    opt = "true";
  };
  plenary-nvim = {
    pname = "plenary-nvim";
    version = "2d9b06177a975543726ce5c73fca176cedbffe9d";
    src = fetchFromGitHub {
      owner = "nvim-lua";
      repo = "plenary.nvim";
      rev = "2d9b06177a975543726ce5c73fca176cedbffe9d";
      fetchSubmodules = false;
      sha256 = "sha256-bmmPekAvuBvLQmrnnX0n+FRBqfVxBsObhxIEkDGAla4=";
    };
    date = "2024-09-17";
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
    version = "v3.13.3";
    src = fetchFromGitHub {
      owner = "folke";
      repo = "which-key.nvim";
      rev = "v3.13.3";
      fetchSubmodules = false;
      sha256 = "sha256-P3Uugc+RPsRVD/kFCmHDow3PLeb2oXEbNX3WzoZ9xlw=";
    };
    opt = "true";
  };
}
