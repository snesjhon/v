require("snacks").setup({
  picker = {
    enabled = true,
    sources = {
      files = { cmd = "rg" },
    },
  },
  dashboard = {
    enabled = true,
    preset = {
      header = [[
██╗   ██╗
██║   ██║
╚██╗ ██╔╝
 ╚████╔╝
  ╚═══╝]],
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
    },
  },
})
