-- v: a minimal, preconfigured Neovim distribution.
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
vim.opt.rtp:prepend(root)

vim.g.mapleader = " "

require("options")
require("mappings")
require("plugins")
require("lsp")

-- User overrides --------------------------------------------------------
-- Opt-in: if ~/.config/v/init.lua exists, load it on top of the defaults
-- above. Survives upgrades since it never touches this bundled file.
local user_config = vim.fn.stdpath("config") .. "/init.lua"
if vim.fn.filereadable(user_config) == 1 then
  dofile(user_config)
end
