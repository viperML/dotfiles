local lspconfig = require("lspconfig")
local root_pattern = lspconfig.util.root_pattern

vim.filetype.add {
  extension = {
    ["nomad"] = "hcl"
  },
  filename = {
    [".envrc"] = "bash",
    ["gitconfig"] = "gitconfig",
    [".guix-channel"] = "scheme",
  },
}

return {
  ["rnix"] = {
    cmd = { "nil" },
    settings = {
      ["nil"] = {
        nix = {
          flake = {
            autoArchive = false,
          },
        },
      },
    },
  },
  ["rust_analyzer"] = {
    settings = {
      ["rust-analyzer"] = {
        imports = {
          granularity = {
            group = "module",
          },
          prefix = "self",
        },
        cargo = {
          buildScripts = {
            enable = true,
          },
        },
        procMacro = {
          enable = true,
        },
      },
    },
  },
  -- JS
  ["astro"] = {},
  ["ts_ls"] = {},
  ["html"] = {},
  ["tailwindcss"] = {},
  ["cssls"] = {},
  ["volar"] = {},
  -- C
  ["clangd"] = {},
  ["mesonlsp"] = {},
  ["neocmake"] = {},
  -- Python
  ["ruff"] = {},
  -- ["pylsp"] = {},
  ["basedpyright"] = {},
  -- Schemas
  ["taplo"] = {},
  ["jsonls"] = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas {
          select = {
            "package.json",
            "tsconfig.json",
          },
        },
        -- validate = { enable = true },
      },
    },
  },
  ["yamlls"] = {
    settings = {
      redhat = {
        telemetry = {
          enabled = false,
        },
      },
      yaml = {
        validate = true,
        schemaStore = {
          enable = false,
          url = "",
        },
        schemas = {
          ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = ".gitlab-ci.{yaml,yml}",
          ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*",
          ["https://raw.githubusercontent.com/canonical/cloud-init/main/cloudinit/config/schemas/versions.schema.cloud-config.json"] = "user-data.{yaml,yml}",
          ["https://json.schemastore.org/hugo.json"] = "hugo.{yaml,yml}",
          -- Spack
          ["https://raw.githubusercontent.com/spack/schemas/refs/heads/main/schemas/spack.json"] = "spack.yaml",
          ["https://raw.githubusercontent.com/spack/schemas/refs/heads/main/schemas/packages.json"] = ".spack/packages.yaml",
          ["https://raw.githubusercontent.com/spack/schemas/refs/heads/main/schemas/config.json"] = ".spack/config.yaml",
          ["https://raw.githubusercontent.com/spack/schemas/refs/heads/main/schemas/modules.json"] = ".spack/modules.yaml",
          ["https://raw.githubusercontent.com/spack/schemas/refs/heads/main/schemas/mirrors.json"] = ".spack/mirrors.yaml",
          ["https://raw.githubusercontent.com/spack/schemas/refs/heads/main/schemas/concretizer.json"] = ".spack/concretizer.yaml",
          ["https://raw.githubusercontent.com/spack/schemas/refs/heads/main/schemas/ci.json"] = ".spack/ci.yaml",
        },
      },
    },
  },
  -- Misc
  ["bashls"] = {},
  ["ltex_plus"] = {
    filetypes = {
      "markdown",
      "mdx",
      "org",
      "tex",
      "typst",
    },
  },
  ["gopls"] = {},
  ["zls"] = {
    enable_build_on_save = true,
  },
  ["tinymist"] = {
    offset_encoding = "utf-8",
  },
  -- ["lua_ls"] = {},
  ["terraformls"] = {},
  ["dockerls"] = {},
  ["guile_ls"] = {
    filetypes = { "scheme" },
  },
}
