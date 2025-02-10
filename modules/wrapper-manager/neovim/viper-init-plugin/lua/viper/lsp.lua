local lspconfig = require("lspconfig")
local DEBUG = vim.log.levels.DEBUG
local levels = vim.log.levels

local capabilities = lspconfig.util.default_config.capabilities

capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
      require("nvim-navic").attach(client, bufnr)
    end
  end,
  capabilities = capabilities,
})

vim.keymap.set("n", "<leader>.", vim.lsp.buf.hover, { desc = "LSP hover" })
vim.keymap.set({ "n", "i" }, "<C-.>", vim.lsp.buf.code_action, { desc = "LSP action" })
vim.keymap.set({ "n", "i" }, "<C-Space>", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "LSP toggle inlay hints" })
vim.keymap.set("n", "<leader>,", vim.diagnostic.open_float, { desc = "LSP diagnostics" })
vim.keymap.set({ "n", "i" }, "<F2>", vim.lsp.buf.rename, { desc = "Rename symbol" })

vim.g.markdown_fenced_languages = {
  "ts=typescript",
}

vim.diagnostic.config {
  virtual_text = false,
}

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

local function setup_all()
  for k, v in pairs(require("viper.lsp_config")) do
    lspconfig[k].setup(v)
  end
end

setup_all()

local function direnv()
  vim.notify("Loading direnv")

  if vim.fn.executable("direnv") ~= 1 then
    vim.notify("Direnv executable not found!")
  end

  vim.api.nvim_clear_autocmds { group = "lspconfig" }
  pcall(function()
    vim.lsp.stop_client(vim.lsp.get_clients(), true)
  end)

  vim.system({ "direnv", "export", "vim" }, {}, function(obj)
    vim.schedule(function()
      vim.fn.execute(obj.stdout)
      setup_all()
      vim.notify("Finished loading direnv")
    end)
  end)
end

vim.api.nvim_create_user_command("Direnv", direnv, {})

vim.api.nvim_create_autocmd({ "DirChanged" }, {
  callback = direnv,
})
