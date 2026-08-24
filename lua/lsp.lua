vim.lsp.config("vtsls", {
  cmd = { "vtsls", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})
vim.lsp.enable("vtsls")

vim.diagnostic.config({ virtual_text = { spacing = 2, prefix = "●" } })
