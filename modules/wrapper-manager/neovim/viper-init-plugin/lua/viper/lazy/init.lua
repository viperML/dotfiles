local M = {}
local _finished = false

M.finish = function()
  require("lz.n").load(require("viper.lazy.specs"))
  _finished = true
end

---@param name string
M.packadd = function(name)
  vim.api.nvim_cmd({
    cmd = "packadd",
    args = { name },
  }, {})
end

---@param specs lz.n.Spec[]
M.add_specs = function(specs)
  if _finished then
    vim.notify("Cannot add specs after finishing", vim.log.levels.ERROR)
    return
  end
  vim.list_extend(require("viper.lazy.specs"), specs)
end

return M
