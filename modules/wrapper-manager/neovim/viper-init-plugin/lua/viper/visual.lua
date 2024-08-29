-- vim.cmd("colorscheme base16-tomorrow-night")
--
-- vim.g.transparent_enabled = true
-- require("transparent").setup {}
--
require("kanagawa").setup {
  transparent = true,
  theme = "dragon",
}

vim.cmd([[ colorscheme kanagawa-dragon ]])

vim.opt.termguicolors = true

require("bufferline").setup {
  options = {
    -- always_show_bufferline = false,
    right_mouse_command = nil,
    middle_mouse_command = "bdelete! %d",
    indicator = {
      style = " ",
    },
  },
}

require("lualine").setup {
  options = {
    globalstatus = true,
    theme = "kanagawa",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      "statusline",
      "winbar",
      "neo-tree",
    },
  },
  winbar = {
    lualine_c = {
      "filename",
      {
        "navic",
        color_correction = nil,
        navic_opts = {},
      },
    },
  },
  inactive_winbar = {
    lualine_c = {
      "filename",
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff" },
    lualine_c = { "diagnostics" },
    lualine_x = {
      {
        "fileformat",
        symbols = {
          unix = "unix",
          dos = "dos",
          mac = "mac",
        },
      },
      "encoding",
      "filesize",
    },
    lualine_y = { "filetype" },
    lualine_z = { "location" },
  },
}

require("dressing").setup {}

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.keymap.set("n", "<Leader>sv", "<cmd>vnew<cr>", { desc = "Split vertically" })
vim.keymap.set("n", "<Leader>sh", "<cmd>new<cr>", { desc = "Split horizontally" })

vim.list_extend(require("viper.lazy.specs"), {
  {
    "neo-tree.nvim",
    cmd = "Neotree",
    keys = { "<leader>b" },
    after = function()
      require("neo-tree").setup {
        default_component_configs = {
          symlink_target = {
            enabled = true,
          },
        },
        close_if_last_window = true,
        filesystem = {
          group_empty_dirs = true,
          use_libuv_file_watcher = true,
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {
              "node_modules",
              ".git",
            },
          },
          follow_current_file = {
            enabled = true,
            leave_dirs_open = true,
          },
        },
      }
      vim.keymap.set("n", "<leader>b", "<cmd>Neotree show toggle<cr>", { desc = "Neotree toggle" })
    end,
  },
  {
    "gitsigns.nvim",
    event = "DeferredUIEnter",
    after = function()
      local gitsigns = require("gitsigns")
      gitsigns.setup()

      vim.keymap.set("n", "<leader>ga", gitsigns.stage_hunk, { desc = "Git: stage hunk" })
      vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Git: preview hunk" })
      vim.keymap.set("n", "<leader>gb", function()
        gitsigns.blame_line { full = true }
      end, { desc = "Git: blame line" })
    end,
  },
  {
    "telescope.nvim",
    cmd = "Telescope",
    keys = { "<leader><leader>", "<leader>f" },
    after = function()
      require("telescope").setup {
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
      }

      -- require("viper.lazy").packadd("telescope-fzf-native.nvim")
      require("telescope").load_extension("fzf")

      vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope find_files<cr>", { desc = "Telescope: find files" })
      vim.keymap.set("n", "<leader>f", "<cmd>Telescope live_grep<cr>", { desc = "Telescope: grep" })
    end,
  },
  {
    "which-key.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("which-key").setup {
        icons = {
          mappings = false,
        },
      }
    end,
  },
  {
    "git-conflict.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("git-conflict").setup()
      vim.keymap.set("n", "<leader>g<Up>", "<cmd>GitConflictChooseOurs<cr>", { desc = "Git conflict: select ours" })
      vim.keymap.set(
        "n",
        "<leader>g<Down>",
        "<cmd>GitConflictChooseTheirs<cr>",
        { desc = "Git conflict: select theirs" }
      )
      vim.keymap.set("n", "<leader>g<Right>", "<cmd>GitConflictChooseBoth<cr>", { desc = "Git conflict: select both" })
    end,
  },
  {
    "vim-better-whitespace",
    event = "DeferredUIEnter",
    before = function()
      vim.g.better_whitespace_enabled = 1
    end,
  },
  {
    "smart-splits.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("smart-splits").setup {}
      vim.keymap.set("n", "<C-Left>", require("smart-splits").move_cursor_left, { desc = "Move left" })
      vim.keymap.set("n", "<C-Down>", require("smart-splits").move_cursor_down, { desc = "Move down" })
      vim.keymap.set("n", "<C-Up>", require("smart-splits").move_cursor_up, { desc = "Move up" })
      vim.keymap.set("n", "<C-Right>", require("smart-splits").move_cursor_right, { desc = "Move right" })

      vim.keymap.set("n", "<C-S-Left>", require("smart-splits").resize_left, { desc = "Resize left" })
      vim.keymap.set("n", "<C-S-Down>", require("smart-splits").resize_down, { desc = "Resize down" })
      vim.keymap.set("n", "<C-S-Up>", require("smart-splits").resize_up, { desc = "Resize up" })
      vim.keymap.set("n", "<C-S-Right>", require("smart-splits").resize_right, { desc = "Resize right" })
    end,
  },
})

local colorcolumns = {
  "rust",
  "scheme",
  ["python"] = 80,
  "lua",
  ["markdown"] = 80,
}

for key, value in pairs(colorcolumns) do
  local lang
  local col

  if type(key) == "string" then
    lang = key
    col = value
  else
    lang = value
    col = 100
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = lang,
    callback = function()
      vim.opt_local.colorcolumn = "" .. col
    end,
  })
end
