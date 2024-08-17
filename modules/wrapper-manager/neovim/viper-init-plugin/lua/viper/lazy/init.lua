local M = {}

M.finish = function()
  require("lz.n").load(require("viper.lazy.specs"))
end

M.packadd = function(name)
  vim.api.nvim_cmd({
    cmd = 'packadd',
    args = {name}
  }, {})
end

return M
