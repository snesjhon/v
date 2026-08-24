local function setup()
  require("bufferline").setup({
    options = {
      diagnostics = "nvim_lsp", -- still colors each tab's filename by severity
      custom_areas = {
        right = function()
          local segments = {}

          local cursor = vim.api.nvim_win_get_cursor(0)
          table.insert(segments, { text = " " .. cursor[1] .. ":" .. (cursor[2] + 1) .. " ", link = "BufferLineFill" })

          local ft = vim.bo.filetype
          if ft ~= "" then table.insert(segments, { text = ft .. " ", link = "BufferLineFill" }) end

          local count = vim.diagnostic.count(0)
          local errors = count[vim.diagnostic.severity.ERROR] or 0
          local warnings = count[vim.diagnostic.severity.WARN] or 0
          if errors > 0 then
            table.insert(segments, { text = " " .. errors .. (errors == 1 and " error " or " errors "), link = "BufferLineError" })
          elseif warnings > 0 then
            table.insert(segments, { text = " " .. warnings .. (warnings == 1 and " warning " or " warnings "), link = "BufferLineWarning" })
          end

          return segments
        end,
      },
    },
    highlights = require("gitlab-theme").bufferline({ theme = require("configs.theme").name }),
  })
end

setup()

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "WinEnter" }, {
  callback = function() vim.cmd("redrawtabline") end,
})
vim.api.nvim_create_autocmd("ColorScheme", { callback = setup })
