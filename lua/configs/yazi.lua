local Snacks = require("snacks")

local chooser = vim.fn.tempname()
local cmd = { "yazi", "--chooser-file=" .. chooser }
local origin_win

local function toggle()
  local before_win = vim.api.nvim_get_current_win()
  local terminal, created = Snacks.terminal.get(cmd, { auto_close = false })

  if created then
    origin_win = before_win
    terminal:on("TermClose", function()
      vim.schedule(function()
        local picked = vim.fn.filereadable(chooser) == 1 and vim.fn.readfile(chooser)[1] or nil
        vim.fn.delete(chooser)
        terminal:close()
        if picked and picked ~= "" and origin_win and vim.api.nvim_win_is_valid(origin_win) then
          vim.api.nvim_set_current_win(origin_win)
          vim.cmd("edit " .. vim.fn.fnameescape(picked))
        end
      end)
    end, { buf = true })
    return
  end

  if not terminal:valid() then origin_win = before_win end
  terminal:toggle()
end

vim.keymap.set({ "n", "t" }, "<F6>", toggle, { desc = "Toggle yazi" })
