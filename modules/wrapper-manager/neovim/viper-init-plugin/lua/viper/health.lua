local M = {}

M.loaded = false

local externals = {
  "date",
  "direnv",
}

M.aichat_config = false

M.check = function()
  vim.health.start("Configuration")
  if M.loaded then
    vim.health.ok("loaded properly")
  else
    vim.health.error("didn't load properly")
  end

  vim.health.start("External programs")
  for _, external in ipairs(externals) do
    if vim.fn.executable(external) == 1 then
      vim.health.ok(external .. " found")
    else
      vim.health.error(external .. " not found")
    end
  end

  vim.health.start("AiChat")
  if M.aichat_config then
    vim.health.ok("Using ~/.config/aichat/config.yaml")
  else
    vim.health.error("Didn't find ~/.config/aichat/config.yaml")
  end
end

M.loaded_exit = function()
  if M.loaded then
    print(":: Health OK")
  else
    print(":: Health FAIL")
    require("os").exit(1)
  end
end

return M
