local M = {}

M.loaded = false

M.check = function()
  vim.health.start("Configuration")
  if M.loaded then
    vim.health.ok("loaded properly")
  else
    vim.health.error("didn't load properly")
  end

  vim.health.start("External programs")
  if vim.fn.executable("direnv") == 1 then
    vim.health.ok("direnv found")
  else
    vim.health.error("direnv not found")
  end
end

return M
