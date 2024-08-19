local nvim_lsp = require("lspconfig")
local root_pattern = nvim_lsp.util.root_pattern

vim.filetype.add {
  filename = { [".envrc"] = "bash" },
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
  -- tsconfig.json in both, but should be fine with direnv+not having both on PATH at the same time
  ["tsserver"] = {
    root_dir = root_pattern("package.json", "tsconfig.json"),
    single_file_support = false,
  },
  ["denols"] = {
    root_dir = root_pattern("deno.json", "deno.jsonc", "tsconfig.json"),
  },
  ["html"] = {},
  ["cssls"] = {},
  ["astro"] = {},
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
        },
      },
    },
  },
  -- Misc
  ["bashls"] = {},
  ["ltex"] = {
    filetypes = {
      "markdown",
      "org",
      "tex",
    },
  },
  ["hls"] = {},
  ["gopls"] = {},
  ["typst_lsp"] = {},
  ["texlab"] = {},
  ["zls"] = {},
}
