vim.list_extend(require("viper.lazy.specs"), {
  {
    "avante.nvim",
    event = "DeferredUIEnter",
    after = function()
      local os = require("os")
      local p = require("posix.stdlib")
      local f, err = loadfile(os.getenv("HOME") .. "/.secrets.lua")
      if err ~= nil then
        return
      end

      ---@type table
      ---@diagnostic disable-next-line: need-check-nil
      local secrets = f()
      p.setenv("DEEPSEEK_APIKEY", secrets.deepseek_apikey)
      local endpoint = secrets.deepseek_endpoint

      require("avante_lib").load()
      require("avante").setup {
        provider = "deepseek",
        hints = { enabled = false },
        vendors = {
          deepseek = {
            __inherited_from = "openai",
            api_key_name = "DEEPSEEK_APIKEY",
            endpoint = endpoint,
            model = "deepseek-r1:32b",
            disable_tools = true,
          },
        },
      }
      -- vim.notify("Avante OK")
    end,
  },
})
