-- ============================================================================
-- LEADER KEY CONFIGURATION
-- ============================================================================
-- Disable space in normal mode to prevent conflicts with leader key
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
-- Set space as the leader key for custom keybindings
vim.g.mapleader = " "
-- Set space as the local leader key for filetype-specific keybindings
vim.g.maplocalleader = " "

-- ============================================================================
-- INDENTATION AND TABS
-- ============================================================================
-- Convert tabs to spaces
vim.opt.expandtab = true
-- Number of spaces a tab character represents
vim.opt.tabstop = 4
-- Number of spaces inserted when pressing Tab in insert mode
vim.opt.softtabstop = 4
-- Number of spaces used for auto-indentation (0 = use tabstop value)
vim.opt.shiftwidth = 0

-- ============================================================================
-- UI AND DISPLAY
-- ============================================================================
-- Disable line numbers in the gutter
vim.opt.number = false
-- Keep at least 2 lines visible above/below cursor when scrolling
vim.opt.scrolloff = 2
-- Hide mode indicator (e.g., -- INSERT --) as it's shown in statusline
vim.opt.showmode = false
-- Enable reading vim settings from file comments (e.g., vim: set tw=80:)
vim.opt.modeline = true
-- Always show sign column with width of 2 characters (prevents text shift)
vim.opt.signcolumn = "yes:2"

-- ============================================================================
-- TIMING AND RESPONSIVENESS
-- ============================================================================
-- Enable timeout for mapped sequences
vim.o.timeout = true
-- Time in milliseconds to wait for a mapped sequence to complete
vim.o.timeoutlen = 500

-- ============================================================================
-- MESSAGES AND COMMAND LINE
-- ============================================================================
-- Hide command line when not in use (saves screen space)
vim.o.cmdheight = 0
-- Abbreviate messages to avoid "press enter" prompts
-- a: all abbreviations, o: overwrite messages, O: file read messages
-- s: search count, t: truncate file messages, T: truncate other messages
-- W: don't show "written" message, I: no intro message
-- C: no completion scan messages, F: no file info when editing
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
-- Character to show at start of wrapped lines
vim.o.showbreak = "↪ "

-- ============================================================================
-- SESSION MANAGEMENT
-- ============================================================================
-- Don't save folds when creating sessions (simplifies session files)
vim.opt.sessionoptions:remove("folds")

-- ============================================================================
-- PLUGIN LOADING
-- ============================================================================
require("viper.lazy").add_specs {

}

-- ============================================================================
-- KEYBINDINGS: WORD NAVIGATION
-- ============================================================================
-- Ctrl+Arrow for word-based navigation (similar to other editors)
vim.keymap.set({ "n", "v" }, "<C-Right>", "e", { desc = "Jump to next word" })
vim.keymap.set({ "n", "v" }, "<C-Left>", "b", { desc = "Jump to previous word" })
vim.keymap.set("n", "<C-S-Right>", "ve", { desc = "Select to next word" })
vim.keymap.set("n", "<C-S-Left>", "vb", { desc = "Select to previous word" })

-- ============================================================================
-- KEYBINDINGS: WORD DELETION
-- ============================================================================
-- Ctrl+Backspace to delete previous word in insert mode
vim.keymap.set('i', '<C-BS>', '<C-w>', { desc = 'Delete word backward' })
-- Ctrl+Delete to delete next word in insert mode
vim.keymap.set("i", "<C-Del>", "<esc><Right>ce")

-- ============================================================================
-- KEYBINDINGS: PREVENT UNINTENDED SELECTIONS
-- ============================================================================
-- Disable Shift/Ctrl+Arrow triggering visual mode unintentionally
vim.keymap.set({ "n", "i", "v" }, "<S-Up>", "<Up>")
vim.keymap.set({ "n", "i", "v" }, "<S-Down>", "<Down>")
vim.keymap.set({ "n", "i", "v" }, "<C-Up>", "<Up>")
vim.keymap.set({ "n", "i", "v" }, "<C-Down>", "<Down>")

-- ============================================================================
-- SEARCH CONFIGURATION
-- ============================================================================
-- Ctrl+F to search in current file
vim.keymap.set({ "n", "v", "i" }, "<C-F>", "/", { desc = "Search in file" })
-- Case-insensitive search by default
vim.opt.ignorecase = true
-- Override ignorecase if search pattern contains uppercase letters
vim.opt.smartcase = true

-- ============================================================================
-- WINDOW SPLITS
-- ============================================================================
-- New horizontal splits appear below current window
vim.opt.splitbelow = true
-- New vertical splits appear to the right of current window
vim.opt.splitright = true

-- Character to fill empty lines below end of buffer
vim.o.fillchars = "eob:~"
