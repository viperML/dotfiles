-- First for vim.notify
require("fidget").setup {
  notification = {
    override_vim_notify = true,
    view = {
      stack_upwards = false,
    },
    window = {
      winblend = 0,
      align = "top",
    },
  },
}

vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 0 -- use tabstop

vim.opt.number = true

vim.opt.scrolloff = 2
vim.opt.showmode = false
vim.opt.modeline = true
vim.opt.signcolumn = "yes"

vim.o.timeout = true
vim.o.timeoutlen = 500

vim.o.cmdheight = 1
vim.o.shortmess = "atToOCFI"
local messages = {
  "a",
  "o",
  "O",
  "s",
  "t",
  "T",
  "W",
  "I",
  "C",
  "F",
}
local messages_res = ""
for _, m in ipairs(messages) do
  messages_res = messages_res .. m
end
vim.o.shortmess = messages_res

vim.o.showbreak = "↪ "

vim.opt.sessionoptions:remove("folds")

vim.list_extend(require("viper.lazy.specs"), {
  {
    "vim-nix",
    ft = { "nix" },
  },
  {
    "neovim-session-manager",
    -- event = "DeferredUIEnter",
    cmd = "SessionManager",
    keys = { "<leader>p" },
    after = function()
      local session_config = require("session_manager.config")
      require("session_manager").setup {
        autoload_mode = session_config.AutoloadMode.Disabled,
      }

      vim.keymap.set("n", "<leader>p", require("session_manager").load_session, { desc = "Project: open" })
    end,
  },
})

-- Auto save feature
vim.opt.updatetime = 500
vim.g.autosave = false
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "InsertLeave" }, {
  callback = function()
    if vim.g.autosave == true then
      local buf = vim.api.nvim_get_current_buf()

      if vim.fn.getbufvar(buf, "&modifiable") == 1 then
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("silent! write")
        end)
      end
    end
  end,
})

vim.api.nvim_create_user_command("ToggleAutoSave", function(args)
  if vim.g.autosave == true then
    vim.g.autosave = false
    vim.notify("Disabled auto save")
  else
    vim.g.autosave = true
    vim.notify("Enabled auto save")
  end
end, {})

-- Alt+Movement like in fish
vim.keymap.set({ "n", "v" }, "<M-Right>", "e")
vim.keymap.set({ "n", "v" }, "<M-Left>", "b")

vim.api.nvim_create_user_command("Date", function()
  vim.system({ "date", "--utc", "+%Y-%m-%dT%H:%M:%SZ" }, { text = true }, function(obj)
    vim.schedule(function()
      local res = obj.stdout:gsub("^%s+", ""):gsub("%s+$", "")
      vim.api.nvim_put({ res }, "c", true, true)
    end)
  end)
end, { desc = "Insert current date" })
