-- local lspconfig = require("lspconfig")
local lspconfig = vim.lsp.config
-- local root_pattern = lspconfig.util.root_pattern

vim.filetype.add {
  extension = {
    ["nomad"] = "hcl"
  },
  filename = {
    [".envrc"] = "bash",
    ["gitconfig"] = "gitconfig",
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
  -- C
  -- ["clangd"] = {},
  ["ccls"] = {},
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
        customTags = {
          "!reference sequence"
        },
        schemaStore = {
          enable = false,
          url = "",
        },
        schemas = {
          ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = ".gitlab-ci.yml",
          ["https://json.schemastore.org/github-action.json"] = "action.{yaml,yml}",
          ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*",
          ["https://raw.githubusercontent.com/canonical/cloud-init/main/cloudinit/config/schemas/versions.schema.cloud-config.json"] = "user-data.{yaml,yml}",
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
  ["tinymist"] = {
    offset_encoding = "utf-8",
  },
  -- ["lua_ls"] = {},
  ["terraformls"] = {},
  ["dockerls"] = {},
}
