local M = {}

M.check = function()
  vim.health.start("External programs")

  if vim.fn.executable("direnv") == 1 then
    vim.health.ok("direnv found")
  else
    vim.health.error("direnv not found")
  end
end

return M
