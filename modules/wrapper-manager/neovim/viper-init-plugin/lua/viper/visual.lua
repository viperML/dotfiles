local M = {}

M.ignored = {
  "node_modules",
  ".direnv",
  "target",
  "build",
  "builddir",
  ".git",
  "dist-newstyle",
}

vim.opt.termguicolors = true

require("kanagawa").setup {
  compile = true,
  -- transparent = true,
  theme = "dragon",
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none",
        },
      },
    },
    palette = {
      -- dragonBlack3 = "#121212",
      dragonBlack3 = "#1D1D1D",
    },
  },
  -- override = function()
  --   return {
  --     NormalFloat = { bg = "none" },
  --     FloatBorder = { bg = "none" },
  --     FloatTitle = { bg = "none" },
  --   }
  -- end,
}

vim.cmd([[ colorscheme kanagawa-dragon ]])

local highlights = {
  constant = vim.api.nvim_get_hl(0, {
    name = "Constant",
  }),
}

vim.api.nvim_set_hl(0, "@markup.strong", {
  cterm = {
    bold = true,
  },
  -- gui = "bold",
  fg = highlights.constant.fg,
})

require("bufferline").setup {
  options = {
    right_mouse_command = nil,
    middle_mouse_command = "bdelete! %d",
    indicator = {
      style = " ",
    },
    numbers = "buffer_id",
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
  extensions = { "neo-tree", "trouble" },
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
      {
        "navic",
        color_correction = nil,
        navic_opts = {},
      },
    },
  },
  sections = {
    lualine_a = { {
      "mode",
      fmt = function(str)
        return " " .. str
      end,
    } },
    lualine_b = {},
    lualine_c = {
      {
        "filename",
        path = 1,
        file_status = false,
      },
      {
        "location",
        fmt = function(str)
          return string.gsub(str, "^%s*(.-)%s*$", "%1")
        end,
      },
    },

    lualine_x = {
      {
        "fileformat",
        symbols = {
          unix = "",
          dos = "CRLF",
          mac = "MAC",
        },
      },
      "encoding",
      "filetype",
      "branch",
      -- "filesize",
    },
    lualine_y = { {
      "diagnostics",
      always_visible = true,
    } },
    lualine_z = {},
  },
}

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.keymap.set("n", "<Leader>sv", "<cmd>vnew<cr>", { desc = "Split vertically" })
vim.keymap.set("n", "<Leader>sh", "<cmd>new<cr>", { desc = "Split horizontally" })

local render_markodwn_fts = { "markdown", "codecompanion", "Avante" }

require("viper.lazy").add_specs {
  {
    "neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      {
        "<leader>b",
        "<cmd>Neotree show toggle<cr>",
        { desc = "Neotree toggle" },
      },
    },
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
            hide_by_name = M.ignored,
          },
          follow_current_file = {
            enabled = true,
            leave_dirs_open = true,
          },
        },
      }
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
    keys = { "<leader><leader>", "<leader>f", "<C-S-F>" },
    after = function()
      require("viper.lazy").packadd("telescope-fzf-native.nvim")
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

      vim.keymap.set("n", "<leader><leader>", function()
        vim.fn.system("git rev-parse --is-inside-work-tree")
        local res = vim.v.shell_error == 0
        local config = require("telescope.themes").get_ivy {}

        if res then
          config.git_command = { "git", "ls-files", "--exclude-standard", "--cached", "--others" }
          require("telescope.builtin").git_files(config)
        else
          config.hidden = true
          require("telescope.builtin").find_files(config)
        end
      end, { desc = "Telescope: find files" })

      vim.keymap.set({ "n", "i" }, "<C-S-F>", function()
        require("telescope.builtin").live_grep(require("telescope.themes").get_ivy {})
      end, { desc = "Telescope: find in all files" })
      --
      -- vim.keymap.set({ "n", "i" }, "", function()
      --   require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {})
      -- end, { desc = "Telescope: find in file" })
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

      local blend = require("snacks.util").blend
      local rgbToHex = require("viper.util").rgbToHex

      local base = vim.api.nvim_get_hl(0, { name = "DiagnosticSignError" }).fg
      local color
      if base ~= nil then
        color = rgbToHex(base)
      else
        color = "#FF0000"
      end

      vim.g.better_whitespace_guicolor = blend("#121212", color, 0.5)
    end,
  },
  {
    "smart-splits.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("smart-splits").setup {}
      vim.keymap.set("n", "<M-Left>", require("smart-splits").move_cursor_left, { desc = "Select panel left" })
      vim.keymap.set("n", "<M-Down>", require("smart-splits").move_cursor_down, { desc = "Select panel down" })
      vim.keymap.set("n", "<M-Up>", require("smart-splits").move_cursor_up, { desc = "Select panel up" })
      vim.keymap.set("n", "<M-Right>", require("smart-splits").move_cursor_right, { desc = "Select panel right" })

      vim.keymap.set("n", "<M-S-Left>", require("smart-splits").resize_left, { desc = "Resize left" })
      vim.keymap.set("n", "<M-S-Down>", require("smart-splits").resize_down, { desc = "Resize down" })
      vim.keymap.set("n", "<M-S-Up>", require("smart-splits").resize_up, { desc = "Resize up" })
      vim.keymap.set("n", "<M-S-Right>", require("smart-splits").resize_right, { desc = "Resize right" })
    end,
  },
  {
    "marks.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("marks").setup {
        mappings = {
          preview = "m:",
        },
      }
    end,
  },
  {
    "render-markdown.nvim",
    ft = render_markodwn_fts,
    after = function()
      require("render-markdown").setup {
        file_types = render_markodwn_fts,
        render_modes = { "n", "i", "c", "t" },
        latex = {
          enabled = false,
        },
        bullet = {
          icons = { "•", "◦" },
        },
      }
    end,
  },
  {
    "yazi.nvim",
    cmd = { "Yazi" },
    keys = {
      {
        "<leader>o",
        "<cmd>Yazi toggle<cr>",
        desc = "Open Yazi",
      },
    },
    lazy = false,
    after = function()
      require("yazi").setup {
        open_for_directories = true,
      }
    end,
  },
}

return M
