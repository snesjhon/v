-- v: a minimal, preconfigured Neovim distribution.
-- Sensible defaults + treesitter/LSP for JS/TS, native vim.pack (no plugin manager).

vim.g.mapleader = " "

-- General -----------------------------------------------------------------
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.swapfile = false

-- UI ------------------------------------------------------------------------
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Indentation -----------------------------------------------------------
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true

-- Search --------------------------------------------------------------------
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Keymaps ---------------------------------------------------------------
vim.keymap.set("n", "<leader>[", "<cmd>vsplit<CR>", { desc = "Vertical split" })

-- Plugins (native vim.pack, no plugin manager plugin) ----------------------
vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/folke/snacks.nvim",
})

-- No-op if already installed.
require("nvim-treesitter").install({ "javascript", "typescript", "tsx" })

-- Search (Snacks picker, backed by ripgrep) ---------------------------------
require("snacks").setup({
  picker = {
    enabled = true,
    sources = {
      files = { cmd = "rg" },
    },
  },
})
vim.keymap.set("n", "<leader>ff", function() require("snacks").picker.files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", function() require("snacks").picker.grep() end, { desc = "Live grep" })

-- Highlighting isn't automatic once a parser is installed; this turns it on
-- per filetype. Core Neovim already maps javascriptreact -> javascript and
-- typescriptreact -> tsx, so no extra parsers are needed for those.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  callback = function() vim.treesitter.start() end,
})

-- LSP (native, JS/TS only) --------------------------------------------------
vim.lsp.config("vtsls", {
  cmd = { "vtsls", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
})
vim.lsp.enable("vtsls")

-- LSP keymaps ---------------------------------------------------------------
-- Buffer-local, only set once a language server actually attaches, so they
-- stay inert on buffers with no LSP client.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.jump { count = 1, float = true } end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.jump { count = -1, float = true } end, opts)
  end,
})

-- User overrides --------------------------------------------------------
-- Opt-in: if ~/.config/v/init.lua exists, load it on top of the defaults
-- above. Survives upgrades since it never touches this bundled file.
local user_config = vim.fn.stdpath("config") .. "/init.lua"
if vim.fn.filereadable(user_config) == 1 then
  dofile(user_config)
end
