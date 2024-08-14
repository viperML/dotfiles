local nvim_lsp = require("lspconfig")
local root_pattern = nvim_lsp.util.root_pattern
local DEBUG = vim.log.levels.DEBUG

vim.filetype.add {
  filename = { [".envrc"] = "bash" },
}

nvim_lsp.util.default_config = vim.tbl_extend("force", nvim_lsp.util.default_config, {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})


vim.keymap.set("n", "<leader>.", vim.lsp.buf.hover, { desc = "LSP hover" })
vim.keymap.set("n", "<C-.>", vim.lsp.buf.code_action, { desc = "LSP action" })
vim.keymap.set("n", "<C-Space>", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "LSP toggle inlay hints" })
vim.keymap.set("n", "<leader>,", vim.diagnostic.open_float, { desc = "LSP diagnostics" })
vim.keymap.set({ "n", "i" }, "<F2>", vim.lsp.buf.rename, { desc = "Rename symbol" })

vim.g.markdown_fenced_languages = {
  "ts=typescript",
}

vim.diagnostic.config {
  virtual_text = false,
}


local configs = {
  ["rnix"] = {
    cmd = { "nil" },
    settings = {
      ["nil"] = {
        nix = {
          flake = {
            autoArchive = false,
          },
        },
      },
    },
  },
  ["rust-analyzer"] = {
    settings = {
      ["rust-analyzer"] = {
        imports = {
          granularity = {
            group = "module",
          },
          prefix = "self",
        },
        cargo = {
          buildScripts = {
            enable = true,
          },
        },
        procMacro = {
          enable = true,
        },
      },
    },
  },
  -- JS
  ["tsserver"] = {
    root_dir = nvim_lsp.util.root_pattern("package.json"),
    single_file_support = false,
  },
  ["denols"] = {
    root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
  },
  ["html"] = {},
  ["cssls"] = {},
  ["astro"] = {},
  -- C
  ["clangd"] = {},
  ["mesonlsp"] = {},
  ["autotools_ls"] = {},
  -- Python
  ["ruff"] = {},
  ["pylsp"] = {},
  -- Schemas
  ["taplo"] = {},
  ["yamlls"] = {
    settings = {
      redhat = {
        telemetry = {
          enabled = false,
        },
      },
      yaml = {
        validate = true,
        schemaStore = {
          enable = false,
          url = "",
        },
        schemas = {
          ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = ".gitlab-ci.{yaml,yml}",
        },
      },
    },
  },
  -- Misc
  ["bashls"] = {},
  ["ltex"] = {
    filetypes = {
      "markdown",
      "org",
      "tex",
    },
  },
  ["hls"] = {},
  ["gopls"] = {},
}

nvim_lsp.util.on_setup = nvim_lsp.util.add_hook_before(nvim_lsp.util.on_setup, function(config)
  config.cmd[1] = vim.fs.basename(config.cmd[1]) -- motherfuckers, who resolved the absolute path

  local bin_name = config.cmd[1]

  local bin_exists = vim.fn.executable(bin_name)

  if bin_exists == 1 then
    config.autostart = true
    vim.notify("Enabling " .. config.name, DEBUG)
  else
    config.autostart = false
    vim.notify("Disabling " .. config.name, DEBUG)
  end
end)

local function setup_all()
  for k, v in pairs(configs) do
    nvim_lsp[k].setup(v)
  end
end

setup_all()

-- vim.api.nvim_create_autocmd({ "DirChanged" }, {
--   pattern = "global",
--   callback = function()
--     pcall(function() vim.lsp.stop_client(vim.lsp.get_clients(), true) end)
--   end
-- })
local function direnv()
    local dir = vim.fn.getcwd()
    vim.notify("> dirchanged " .. dir, DEBUG)

    vim.api.nvim_clear_autocmds { group = "lspconfig" }
    pcall(function()
      vim.lsp.stop_client(vim.lsp.get_clients(), true)
    end)

    local obj = vim.system({ "direnv", "export", "vim" }, {}):wait()
    vim.fn.execute(obj.stdout)

    setup_all()

    vim.notify("< dirchanged " .. dir, DEBUG)
end

vim.api.nvim_create_user_command("Direnv", direnv, {})

vim.api.nvim_create_autocmd({ "SessionLoadPost" }, {
  callback = direnv,
})
