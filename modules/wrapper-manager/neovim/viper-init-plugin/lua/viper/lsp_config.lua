local lspconfig = require("lspconfig")
local root_pattern = lspconfig.util.root_pattern

vim.filetype.add {
  filename = {
    [".envrc"] = "bash",
    ["gitconfig"] = "gitconfig",
  },
}

-- don't show parse errors in a separate window
vim.g.zig_fmt_parse_errors = 0
-- disable format-on-save from `ziglang/zig.vim`
vim.g.zig_fmt_autosave = 0

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
  -- tsconfig.json in both, but should be fine with direnv+not having both on PATH at the same time
  ["ts_ls"] = {
    root_dir = root_pattern("package.json", "tsconfig.json"),
    -- single_file_support = false,
  },
  -- ["denols"] = {
  --   root_dir = root_pattern("deno.json", "deno.jsonc", "tsconfig.json"),
  -- },
  ["html"] = {},
  ["cssls"] = {},
  ["astro"] = {},
  ["eslint"] = {},
  ["tailwindcss"] = {},
  ["mdx_analyzer"] = {},
  -- C
  ["clangd"] = {},
  ["mesonlsp"] = {},
  ["autotools_ls"] = {},
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
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
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
  -- ["hls"] = {
  --   filetypes = { "haskell", "lhaskell", "cabal" },
  -- },
  ["gopls"] = {},
  ["tinymist"] = {
    offset_encoding = "utf-8",
  },
  ["texlab"] = {},
  ["zls"] = {},
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
  ["elixirls"] = {
    cmd = { "elixir-ls" },
  },
  ["asm_lsp"] = {},
  ["terraformls"] = {},
  ["glslls"] = {},
}
