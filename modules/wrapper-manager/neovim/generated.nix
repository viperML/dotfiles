# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  bufferline-nvim = {
    pname = "bufferline-nvim";
    version = "v4.9.0";
    src = fetchFromGitHub {
      owner = "akinsho";
      repo = "bufferline.nvim";
      rev = "v4.9.0";
      fetchSubmodules = false;
      sha256 = "sha256-HbHqArfqFWGxPnJFGUC1DPJmpbzFTNDObFuICPFVVl4=";
    };
  };
  cmp-async-path = {
    pname = "cmp-async-path";
    version = "d6d1ffa2075039632a2d71e8fa139818e15ac757";
    src = fetchgit {
      url = "https://codeberg.org/FelipeLema/cmp-async-path";
      rev = "d6d1ffa2075039632a2d71e8fa139818e15ac757";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-MZFpNPtSDMZNkfoz+3ZcDxLb8PvDtm9nb1dE0CbYIPQ=";
    };
    date = "2024-10-21";
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
    version = "99290b3ec1322070bcfb9e846450a46f6efa50f0";
    src = fetchFromGitHub {
      owner = "hrsh7th";
      repo = "cmp-nvim-lsp";
      rev = "99290b3ec1322070bcfb9e846450a46f6efa50f0";
      fetchSubmodules = false;
      sha256 = "sha256-iaihXNCF5bB5MdeoosD/kc3QtpA/QaIDZVLiLIurBSM=";
    };
    date = "2024-12-10";
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
    version = "v8.2.0";
    src = fetchFromGitHub {
      owner = "stevearc";
      repo = "conform.nvim";
      rev = "v8.2.0";
      fetchSubmodules = false;
      sha256 = "sha256-4/+UXVuJnyqpDDmKsRdD7X2OD2pw22o2zOWtZA0g0BY=";
    };
    opt = "true";
  };
  dressing-nvim = {
    pname = "dressing-nvim";
    version = "fc78a3ca96f4db9f8893bb7e2fd9823e0780451b";
    src = fetchFromGitHub {
      owner = "stevearc";
      repo = "dressing.nvim";
      rev = "fc78a3ca96f4db9f8893bb7e2fd9823e0780451b";
      fetchSubmodules = false;
      sha256 = "sha256-O0sdxU+ZQnclnnC5IfBpgqlMxjsJKlmPYQYPP+S3cn8=";
    };
    date = "2024-11-13";
  };
  fidget-nvim = {
    pname = "fidget-nvim";
    version = "e2a175c2abe2d4f65357da1c98c59a5cfb2b543f";
    src = fetchFromGitHub {
      owner = "j-hui";
      repo = "fidget.nvim";
      rev = "e2a175c2abe2d4f65357da1c98c59a5cfb2b543f";
      fetchSubmodules = false;
      sha256 = "sha256-fQBrkHV54TaOeLYQJ1DE+lr7SFDPN1yqSlzhFm26NAY=";
    };
    date = "2024-10-29";
  };
  git-conflict-nvim = {
    pname = "git-conflict-nvim";
    version = "4dc906855751096aaeba2edde7c2cdc7bb881c98";
    src = fetchFromGitHub {
      owner = "akinsho";
      repo = "git-conflict.nvim";
      rev = "4dc906855751096aaeba2edde7c2cdc7bb881c98";
      fetchSubmodules = false;
      sha256 = "sha256-ajjt1JQaqDTmfL/o4yH1Cszygiejdcv+SCyjCpxSSJ4=";
    };
    opt = "true";
    date = "2024-11-09";
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
    version = "v4.3.2";
    src = fetchFromGitHub {
      owner = "mrcjkb";
      repo = "haskell-tools.nvim";
      rev = "v4.3.2";
      fetchSubmodules = false;
      sha256 = "sha256-8z9XyEnL0DlXkRnmVedfx9YR4ieQrbs4mb/vRkW3Bik=";
    };
  };
  indent-blankline-nvim = {
    pname = "indent-blankline-nvim";
    version = "v3.8.6";
    src = fetchFromGitHub {
      owner = "lukas-reineke";
      repo = "indent-blankline.nvim";
      rev = "v3.8.6";
      fetchSubmodules = false;
      sha256 = "sha256-H3lUQZDvgj3a2STYeMUDiOYPe7rfsy08tJ4SlDd+LuE=";
    };
    opt = "true";
  };
  kaganawa-nvim = {
    pname = "kaganawa-nvim";
    version = "ad3dddecd606746374ba4807324a08331dfca23c";
    src = fetchFromGitHub {
      owner = "rebelot";
      repo = "kanagawa.nvim";
      rev = "ad3dddecd606746374ba4807324a08331dfca23c";
      fetchSubmodules = false;
      sha256 = "sha256-IG+eEhmSDRxRDBvfETeN9f3IjJvCntQm3u72QlY0ytE=";
    };
    date = "2024-11-07";
  };
  lualine-nvim = {
    pname = "lualine-nvim";
    version = "2a5bae925481f999263d6f5ed8361baef8df4f83";
    src = fetchFromGitHub {
      owner = "nvim-lualine";
      repo = "lualine.nvim";
      rev = "2a5bae925481f999263d6f5ed8361baef8df4f83";
      fetchSubmodules = false;
      sha256 = "sha256-IN6Qz3jGxUcylYiRTyd8j6me3pAoqJsJXtFUvph/6EI=";
    };
    date = "2024-11-08";
  };
  lz-n = {
    pname = "lz-n";
    version = "v2.9.2";
    src = fetchFromGitHub {
      owner = "nvim-neorocks";
      repo = "lz.n";
      rev = "v2.9.2";
      fetchSubmodules = false;
      sha256 = "sha256-+dKLze48BsPjeBLUBwbyOeu0+/FXyil1PM3XXUUKmkA=";
    };
  };
  mdx-nvim = {
    pname = "mdx-nvim";
    version = "ae83959b61a9fec8da228ebb5d6b045fd532d2cc";
    src = fetchFromGitHub {
      owner = "davidmh";
      repo = "mdx.nvim";
      rev = "ae83959b61a9fec8da228ebb5d6b045fd532d2cc";
      fetchSubmodules = false;
      sha256 = "sha256-z835i8QkQFe185sgSLtUaaTsMs2Px9x6KTObTRAOFz0=";
    };
    date = "2024-10-28";
  };
  neo-tree-nvim = {
    pname = "neo-tree-nvim";
    version = "ca340e0747a85a05c08a5ba5e183c70c0a355a7c";
    src = fetchFromGitHub {
      owner = "nvim-neo-tree";
      repo = "neo-tree.nvim";
      rev = "ca340e0747a85a05c08a5ba5e183c70c0a355a7c";
      fetchSubmodules = false;
      sha256 = "sha256-5oqw2J42kmpkb4vxVmJ53WQ4y8vDm6m7sLN6kmSQykM=";
    };
    opt = "true";
    date = "2024-12-09";
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
    version = "b464658e9b880f463b9f7e6ccddd93fb0013f559";
    src = fetchFromGitHub {
      owner = "windwp";
      repo = "nvim-autopairs";
      rev = "b464658e9b880f463b9f7e6ccddd93fb0013f559";
      fetchSubmodules = false;
      sha256 = "sha256-LbaxiU3ienVBcMKrug3Coppc4R+MD2rjREw7rHQim1w=";
    };
    date = "2024-11-17";
  };
  nvim-cmp = {
    pname = "nvim-cmp";
    version = "3403e2e9391ed0a28c3afddd8612701b647c8e26";
    src = fetchFromGitHub {
      owner = "hrsh7th";
      repo = "nvim-cmp";
      rev = "3403e2e9391ed0a28c3afddd8612701b647c8e26";
      fetchSubmodules = false;
      sha256 = "sha256-Aht1m2V+yRvmrLoBC4QGYG/p/tmDbnZe1nT3V5k7S58=";
    };
    date = "2024-12-10";
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
    version = "34282820bb713b9a5fdb120ae8dd85c2b3f49b51";
    src = fetchFromGitHub {
      owner = "mfussenegger";
      repo = "nvim-dap-python";
      rev = "34282820bb713b9a5fdb120ae8dd85c2b3f49b51";
      fetchSubmodules = false;
      sha256 = "sha256-Qz0eZGVy/3q2qBtyliw1bxiJE9NT02F1hZoVNm3KU5g=";
    };
    opt = "true";
    date = "2024-11-29";
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
  nvim-treesitter-context = {
    pname = "nvim-treesitter-context";
    version = "3288c5af7d3820d716272f1d05ab661cc540a5d6";
    src = fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = "nvim-treesitter-context";
      rev = "3288c5af7d3820d716272f1d05ab661cc540a5d6";
      fetchSubmodules = false;
      sha256 = "sha256-1ERiDz2A4NeX54bMgMsIAkSDVXtYA2PBzvJTh7upWoY=";
    };
    date = "2024-12-08";
  };
  nvim-treesitter-textobjects = {
    pname = "nvim-treesitter-textobjects";
    version = "ad8f0a472148c3e0ae9851e26a722ee4e29b1595";
    src = fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = "nvim-treesitter-textobjects";
      rev = "ad8f0a472148c3e0ae9851e26a722ee4e29b1595";
      fetchSubmodules = false;
      sha256 = "sha256-b/7Bz7L83KL+uZC1bRJ4PrzPVK/NaCKSx4VCHlPcdCM=";
    };
    date = "2024-11-22";
  };
  nvim-ts-autotag = {
    pname = "nvim-ts-autotag";
    version = "1cca23c9da708047922d3895a71032bc0449c52d";
    src = fetchFromGitHub {
      owner = "windwp";
      repo = "nvim-ts-autotag";
      rev = "1cca23c9da708047922d3895a71032bc0449c52d";
      fetchSubmodules = false;
      sha256 = "sha256-v2NTFBIzKTYizUPWB3uhpnTGVZWaelhE3MT5+BDA6Do=";
    };
    date = "2024-12-02";
  };
  nvim-web-devicons = {
    pname = "nvim-web-devicons";
    version = "87c34abe5d1dc7c1c0a95aaaf888059c614c68ac";
    src = fetchFromGitHub {
      owner = "nvim-tree";
      repo = "nvim-web-devicons";
      rev = "87c34abe5d1dc7c1c0a95aaaf888059c614c68ac";
      fetchSubmodules = false;
      sha256 = "sha256-CCgSVOviXWE/hzhedh+HlnHSVKMaQVpm3lMkJbu2ec4=";
    };
    date = "2024-12-07";
  };
  oil-nvim = {
    pname = "oil-nvim";
    version = "v2.13.0";
    src = fetchFromGitHub {
      owner = "stevearc";
      repo = "oil.nvim";
      rev = "v2.13.0";
      fetchSubmodules = false;
      sha256 = "sha256-XngiDSpLIAXwqfgtTQDuBSYSSYbhyrD73aT28B6J5H4=";
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
    version = "v1.7.0";
    src = fetchFromGitHub {
      owner = "mrjones2014";
      repo = "smart-splits.nvim";
      rev = "v1.7.0";
      fetchSubmodules = false;
      sha256 = "sha256-5eXheuzUjrFdxD/ddpDLxzCqH92t5LOBBcruUjiSz4g=";
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
    version = "v3.14.1";
    src = fetchFromGitHub {
      owner = "folke";
      repo = "which-key.nvim";
      rev = "v3.14.1";
      fetchSubmodules = false;
      sha256 = "sha256-55RmbdN0rNG8946eIMFd5BlN82eY1GKqmHdUiC7BP+U=";
    };
    opt = "true";
  };
}
