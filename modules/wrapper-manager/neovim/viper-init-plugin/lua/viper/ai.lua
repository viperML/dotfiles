---@param path string
---@return string
local read_file = function(path)
  local a = require("plenary.async")
  local err, fd = a.uv.fs_open(path, "r", 438)
  assert(not err, err)

  local err, stat = a.uv.fs_fstat(fd)
  assert(not err, err)

  local err, data = a.uv.fs_read(fd, stat.size, 0)
  assert(not err, err)

  local err = a.uv.fs_close(fd)
  assert(not err, err)

  return data
end

---@class Model
---@field name string

---@param aichat_config_raw string
local load_aichat_config = function(aichat_config_raw)
  local lyaml = require("lyaml")
  local aichat_config = lyaml.load(aichat_config_raw)

  local aichat_client = aichat_config.clients[1]
  ---@type Model[]
  local models = aichat_client.models

  require("posix.stdlib").setenv("OPENAI_API_KEY", aichat_client.api_key)

  require("avante_lib").load()
  require("avante").setup {
    provider = "openai",
    openai = {
      endpoint = aichat_client.api_base,
      model = "codellama:70b",
      disable_tools = true, -- disable tools!
    },
  }
end

require("viper.lazy").add_specs {
  {
    "avante.nvim",
    event = "DeferredUIEnter",
    after = function()
      local a = require("plenary.async")
      ---@diagnostic disable-next-line: missing-parameter
      a.run(function()
        local err, ret = pcall(function()
          return read_file(vim.fn.expand("~/.config/aichat/config.yaml"))
        end)

        vim.schedule(function()
          if err then
            require("viper.health").aichat_config = true
            load_aichat_config(ret)
          end
        end)
      end)
    end,
  },
}
