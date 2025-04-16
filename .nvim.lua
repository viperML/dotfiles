vim.notify("Hello from dotfiles!")

local rt = vim.api.nvim_get_runtime_file("", true)

vim.lsp.config["lua_ls"] = {
  cmd = { "lua-language-server" },
  single_file_support = false,
  filetypes = { "lua" },
  root_markers = { ".git", ".git/" },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
        library = rt,
      },
    },
  },
}

vim.lsp.enable("lua_ls")
