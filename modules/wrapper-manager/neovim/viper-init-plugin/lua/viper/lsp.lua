local nvim_lsp = require("lspconfig")
local root_pattern = nvim_lsp.util.root_pattern
local DEBUG = vim.log.levels.DEBUG

nvim_lsp.util.default_config = vim.tbl_extend("force", nvim_lsp.util.default_config, {
  capabilities = vim.tbl_extend(
    "force",
    require("cmp_nvim_lsp").default_capabilities(),
    require("lsp-file-operations").default_capabilities()
  ),
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

nvim_lsp.util.on_setup = nvim_lsp.util.add_hook_before(nvim_lsp.util.on_setup, function(config)
  config.cmd[1] = vim.fs.basename(config.cmd[1]) -- motherfuckers, who resolved the absolute path

  local bin_name = config.cmd[1]

  local bin_exists = vim.fn.executable(bin_name)

  if bin_exists == 1 then
    config.autostart = true
    vim.notify("Enabling " .. config.name, DEBUG)
  else
    config.autostart = false
    vim.notify("Disabling " .. config.name, DEBUG)
  end
end)

local function setup_all()
  for k, v in pairs(require("viper.lsp_config")) do
    nvim_lsp[k].setup(v)
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

  local obj = vim.system({ "direnv", "export", "vim" }, {}, function(obj)
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
