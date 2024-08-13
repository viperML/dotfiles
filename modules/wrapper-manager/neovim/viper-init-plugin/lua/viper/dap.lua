local dap = require("dap")

vim.keymap.set({"n", "i", "v"}, "<F9>", dap.toggle_breakpoint, { desc = "Debugger: toggle breakpoint" })
vim.keymap.set({"n", "i", "v"}, "<F5>", dap.continue, { desc = "Debugger: start/continue" })
vim.keymap.set({"n", "i", "v"}, "<F17>", dap.close, { desc = "Debugger: stop" }) -- S+F5 -> F17
vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc= "Debugger: open REPL" })

require("dap-python").setup("python")
