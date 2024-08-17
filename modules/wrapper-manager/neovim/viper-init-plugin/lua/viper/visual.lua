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
    always_show_bufferline = false,
    right_mouse_command = nil,
    middle_mouse_command = "bdelete! %d",
    indicator = {
      style = " ",
    },
  },
}

require("lualine").setup {
  options = {
    theme = "kanagawa",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
}

require("dressing").setup {}

vim.list_extend(require("viper.lazy.specs"), {
  {
    "neo-tree.nvim",
    cmd = "Neotree",
    keys = { "<leader>b" },
    after = function()
      require("neo-tree").setup {
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
})
