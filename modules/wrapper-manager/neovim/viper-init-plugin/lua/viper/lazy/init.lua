local M = {}

M.finish = function()
  require("lz.n").load(require("viper.lazy.specs"))
end

M.packadd = function(name)
  vim.api.nvim_cmd({
    cmd = "packadd",
    args = { name },
  }, {})
end

M.load_once = function(name)
  local state = require("lz.n.state").plugins
  require("lz.n").trigger_load(name)

  for k, v in ipairs(require("lz.n.state").plugins) do
    vim.notify(k)

    if v == name then
      table.remove(require("lz.n.state").plugins, name)
      break
    end
  end
end

---@param specs lz.n.Spec[]
M.add_specs = function(specs)
  vim.list_extend(require("viper.lazy.specs"), specs)
end

return M
