vim.filetype.add {
  filename = { [".envrc"] = "bash" },
}

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
--
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local nvim_lsp = require("lspconfig")

vim.keymap.set("n", "<leader>.", vim.lsp.buf.hover, { desc = "LSP hover" })
vim.keymap.set("n", "<C-.>", vim.lsp.buf.code_action, { desc = "LSP action" })

vim.keymap.set("n", "<C-Space>", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "LSP toggle inlay hints" })

local nil_lsp_config = {}
nil_lsp_config["nil"] = {
  nix = {
    flake = {
      autoArchive = false,
    },
  },
}
nvim_lsp.rnix.setup {
  capabilities = capabilities,
  cmd = { "nil" },
  settings = nil_lsp_config,
}

-- local on_attach = function(client)
--   require("completion").on_attach(client)
-- end

nvim_lsp.rust_analyzer.setup {
  -- on_attach = on_attach,
  capabilities = capabilities,
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
}

vim.g.markdown_fenced_languages = {
  "ts=typescript",
}

nvim_lsp.tsserver.setup {
  capabilities = capabilities,
  root_dir = nvim_lsp.util.root_pattern("package.json"),
  single_file_support = false,
}

nvim_lsp.clangd.setup {
  capabilities = capabilities,
}

nvim_lsp.ltex.setup {
  capabilities = capabilities,
  filetypes = {
    "markdown",
    "org",
    "tex",
  },
}

-- JS
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
nvim_lsp.astro.setup {
  capabilities = capabilities,
}
nvim_lsp.eslint.setup {
  capabilities = capabilities,
}
nvim_lsp.html.setup {
  capabilities = capabilities,
}
nvim_lsp.tsserver.setup {
  capabilities = capabilities,
}
nvim_lsp.cssls.setup {
  capabilities = capabilities,
}
--

nvim_lsp.mesonlsp.setup {
  capabilities = capabilities,
}

nvim_lsp.bashls.setup {
  capabilities = capabilities,
}

nvim_lsp.hls.setup {
  capabilities = capabilities,
}

require("fidget").setup {
  notification = {
    window = {
      winblend = 0,
    }
  }
}

vim.diagnostic.config({
  virtual_text = false,
})

vim.keymap.set("n", "<leader>,", vim.diagnostic.open_float, { desc = "LSP diagnostics" })

vim.keymap.set({"n", "i"}, "<F2>", vim.lsp.buf.rename, { desc = "Rename symbol" })

nvim_lsp.gopls.setup {
  capabilities = capabilities,
}

nvim_lsp.autotools_ls.setup {
  capabilities = capabilities,
}

-- Python
nvim_lsp.ruff.setup {
  capabilities = capabilities,
}
nvim_lsp.pylsp.setup {
  capabilities = capabilities,
}
