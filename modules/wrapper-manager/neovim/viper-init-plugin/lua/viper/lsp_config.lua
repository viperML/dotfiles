local lspconfig = require("lspconfig")
local root_pattern = lspconfig.util.root_pattern

vim.filetype.add {
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
  -- JS
  -- C
  ["clangd"] = {},
  ["mesonlsp"] = {},
  ["neocmake"] = {},
  -- Python
  ["ruff"] = {},
  ["pylsp"] = {},
  -- Schemas
  ["taplo"] = {},
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
  ["zls"] = {},
  ["tinymist"] = {
    offset_encoding = "utf-8",
  },
  ["lua_ls"] = {
    on_init = function(client)
      if os.getenv("NVIM_VIPER_DEBUG") ~= nil then
        local filtered = vim.tbl_filter(function(value)
          local res = vim.startswith(vim.fs.basename(value), "viper")
          return not res
        end, vim.api.nvim_get_runtime_file("", true))
        table.remove(filtered, 1)

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
          runtime = {
            version = "LuaJIT",
          },
          workspace = {
            checkThirdParty = false,
            library = filtered,
          },
        })
      end
    end,
    settings = {
      Lua = {},
    },
  },
  ["terraformls"] = {},
}
