local configs = {
  ["rnix"] = {
    cmd = { "nil" },
  },
  ["rust_analyzer"] = {},
  -- C
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
          "!reference sequence",
          "!vault scalar"
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

vim.filetype.add {
  extension = {
    ["nomad"] = "hcl"
  },
  filename = {
    [".envrc"] = "bash",
    ["gitconfig"] = "gitconfig",
  },
}

for k, v in pairs(configs) do
  vim.lsp.config(k, v)
  vim.lsp.enable(k)
end

require("blink.cmp").setup {
  completion = {
    accept = { auto_brackets = { enabled = true } },
    ghost_text = { enabled = true },
  },
  keymap = {
    preset = "super-tab",
    ["<C-Space>"] = { "show", "fallback" },
  },
  sources = {
    default = {
      "lsp",
      "path",
    },
  },
}

vim.keymap.set("n", "<leader>.", vim.lsp.buf.hover, { desc = "LSP hover" })
vim.keymap.set({ "n", "i" }, "<C-.>", vim.lsp.buf.code_action, { desc = "LSP action" })
vim.keymap.set({ "n", "i" }, "<C-Space>", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "LSP toggle inlay hints" })
vim.keymap.set({ "n", "i" }, "<F2>", vim.lsp.buf.rename, { desc = "Rename symbol" })
