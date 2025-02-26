local a = require("plenary.async")

---@param path string
---@return string
local read_file = function(path)
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
local config_codecompanion = function(aichat_config_raw)
  local lyaml = require("lyaml")
  local aichat_config = lyaml.load(aichat_config_raw)

  local aichat_client = aichat_config.clients[1]
  ---@type Model[]
  local models = aichat_client.models

  ---@param model string
  local function mkAdapter(model)
    return function()
      return require("codecompanion.adapters").extend("openai_compatible", {
        env = {
          url = aichat_client.api_base,
          api_key = aichat_client.api_key,
          chat_url = "/chat/completions",
        },
        schema = {
          model = {
            default = model,
          },
        },
      })
    end
  end

  local adapters = {}
  for _, model in ipairs(models) do
    adapters[model.name] = mkAdapter(model.name)
  end

  adapters.opts = {
    show_defaults = false,
  }

  local default_adapter = models[1].name
  vim.notify(vim.inspect(default_adapter))

  require("codecompanion").setup {
    adapters = adapters,

    strategies = {
      chat = {
        adapter = default_adapter,
      },
      inline = {
        adapter = default_adapter,
      },
    },

    opts = {
      log_level = "DEBUG",
    },
  }
end

require("viper.lazy").add_specs {
  {
    "codecompanion.nvim",
    event = "DeferredUIEnter",
    after = function()
      ---@diagnostic disable-next-line: missing-parameter
      a.run(function()
        vim.health.start("CodeCompanion")
        local err, ret = pcall(function()
          return read_file(vim.fn.expand("~/.config/aichat/config.yaml"))
        end)

        vim.schedule(function()
          if err then
            require("viper.health").aichat_config = true
            config_codecompanion(ret)
          end
        end)
      end)
    end,
  },
}
