local two_tabs_default = {
  "astro",
  -- "c",
  -- "cpp",
  "css",
  "gitconfig",
  "html",
  "javascript",
  "json",
  "jsonc",
  "lua",
  "markdown",
  "mdx",
  "meson",
  "nix",
  "r",
  "terraform",
  "typescript",
  "typst",
}

for _, lang in ipairs(two_tabs_default) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = lang,
    callback = function()
      vim.opt_local.tabstop = 2
    end,
  })
end
