-- local function direnv()
--   vim.notify("Loading direnv")
--
--   if vim.fn.executable("direnv") ~= 1 then
--     vim.notify("Direnv executable not found!")
--   end
--
--   vim.api.nvim_clear_autocmds { group = "lspconfig" }
--   pcall(function()
--     vim.lsp.stop_client(vim.lsp.get_clients(), true)
--   end)
--
--   vim.system({ "direnv", "export", "vim" }, {}, function(obj)
--     vim.schedule(function()
--       vim.fn.execute(obj.stdout)
--       setup_all()
--       vim.notify("Finished loading direnv")
--     end)
--   end)
-- end
--
-- vim.api.nvim_create_user_command("Direnv", direnv, {})
--
-- vim.api.nvim_create_autocmd({ "DirChanged" }, {
--   callback = direnv,
-- })

vim.opt.ignorecase = true
vim.opt.smartcase = true

require("viper.lazy").add_specs {
  {
    "trouble.nvim",
    cmd = "Trouble",
    after = function()
      require("trouble").setup {}
    end,
  },
  {
    "nvim-lspconfig",
    event = "DeferredUIEnter",
    after = function()
      local lspconfig = require("lspconfig")
      require("viper.lazy").packadd("blink.cmp")
      require("viper.lazy").packadd("nvim-navic")

      require("blink.cmp").setup {
        completion = {
          accept = { auto_brackets = { enabled = true } },
          ghost_text = { enabled = true },
        },
        keymap = {
          preset = "super-tab",
          ["<C-Space>"] = { "show", "fallback" },
          ["<C-s>"] = {
            function(cmp)
              cmp.show { providers = { "copilot" } }
            end,
          },
        },
        sources = {
          default = {
            "lsp",
            "path",
            -- "snippets",
            -- "buffer",
            -- "copilot",
          },
          providers = {
            copilot = {
              name = "copilot",
              module = "blink-cmp-copilot",
              score_offset = 100,
              async = true,
            },
          },
        },
      }

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        on_attach = function(client, bufnr)
          if client.server_capabilities.documentSymbolProvider then
            require("nvim-navic").attach(client, bufnr)
          end
        end,
        capabilities = capabilities,
      })

      lspconfig.util.on_setup = lspconfig.util.add_hook_before(lspconfig.util.on_setup, function(config)
        config.cmd[1] = vim.fs.basename(config.cmd[1]) -- motherfuckers, who resolved the absolute path

        local bin_name = config.cmd[1]

        local bin_exists = vim.fn.executable(bin_name)

        if bin_exists == 1 then
          config.autostart = true
        -- vim.notify("Enabling " .. config.name, levels.TRACE)
        else
          config.autostart = false
          -- vim.notify("Disabling " .. config.name, levels.TRACE)
        end
      end)

      for k, v in pairs(require("viper.lsp_config")) do
        lspconfig[k].setup(v)
      end

      vim.keymap.set("n", "<leader>.", vim.lsp.buf.hover, { desc = "LSP hover" })
      vim.keymap.set({ "n", "i" }, "<C-.>", vim.lsp.buf.code_action, { desc = "LSP action" })
      vim.keymap.set({ "n", "i" }, "<C-Space>", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, { desc = "LSP toggle inlay hints" })
      -- vim.keymap.set("n", "<leader>,", vim.diagnostic.open_float, { desc = "LSP diagnostics" })
      vim.keymap.set({ "n", "i" }, "<F2>", vim.lsp.buf.rename, { desc = "Rename symbol" })
    end,
  },
  {
    "nvim-autopairs",
    event = "InsertEnter",
    after = function()
      require("nvim-autopairs").setup {
        disable_filetype = { "scheme", "elisp" },
      }
    end,
  },
}

vim.diagnostic.config {
  virtual_text = {
    prefix = " ",
    ---@param diagnostic vim.Diagnostic
    ---@return string?
    format = function(diagnostic)
      if diagnostic.severity >= vim.diagnostic.severity.INFO then
        return nil
      else
        local it = vim.gsplit(diagnostic.message, "\n")
        return it()
      end
    end,
  },
  jump = {
    float = true,
  },
  float = { border = "single" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
      [vim.diagnostic.severity.INFO] = " ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticErrorLn",
      [vim.diagnostic.severity.WARN] = "DiagnosticWarnLn",
      [vim.diagnostic.severity.INFO] = "DiagnosticInfoLn",
      [vim.diagnostic.severity.HINT] = "DiagnosticHintLn",
    },
  },
}

for _, severity in pairs { "Error", "Warn", "Info", "Hint" } do
  local blend = require("snacks.util").blend
  local rgbToHex = require("viper.util").rgbToHex

  local base = vim.api.nvim_get_hl(0, { name = string.format("DiagnosticSign%s", severity) }).fg
  local color
  if base ~= nil then
    color = rgbToHex(base)
  else
    color = "#FFFFFF" -- FIXME
  end
  vim.api.nvim_set_hl(0, string.format("Diagnostic%sLn", severity), {
    bg = blend("#121212", color, 0.95),
  })
end
