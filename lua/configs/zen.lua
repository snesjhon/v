-- Zen mode -- centers the current window by padding it with two empty side
-- windows, similar in spirit to no-neck-pain.nvim but built from core
-- Neovim only (no external dependency).
local M = {}

local width = 120
local state = nil -- { main = winid, left = winid, right = winid }
local awaiting_reenable = false -- a real split is open; re-pad once it closes

local function side_win(cmd)
  vim.cmd(cmd)
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buf)
  -- Non-modifiable: nothing typed here can ever set 'modified', so closing
  -- these windows can never be blocked by (or discard) real content.
  vim.bo[buf].modifiable = false
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].cursorline = false
  vim.wo[win].winfixwidth = true
  vim.wo[win].fillchars = "eob: "
  vim.wo[win].statusline = " "
  return win
end

-- The main window's width changes as a side effect of adding/removing the
-- pads, but Neovim doesn't fire WinResized for that on its own. Width-aware
-- content (e.g. snacks' dashboard, which centers text based on window width
-- at render time) needs this nudge to re-layout for the new width.
local function notify_resize() vim.api.nvim_exec_autocmds("WinResized", {}) end

local function off()
  if not state then return end
  for _, win in ipairs({ state.left, state.right }) do
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
  end
  state = nil
  notify_resize()
end

local function on()
  local main = vim.api.nvim_get_current_win()
  local pad = math.floor((vim.o.columns - width) / 2)
  if pad <= 0 then return end

  local left = side_win("leftabove vsplit")
  vim.api.nvim_win_set_width(left, pad)

  vim.api.nvim_set_current_win(main)
  local right = side_win("rightbelow vsplit")
  vim.api.nvim_win_set_width(right, pad)

  vim.api.nvim_set_current_win(main)
  state = { main = main, left = left, right = right }
  notify_resize()
end

function M.toggle()
  if state then
    off()
  else
    on()
  end
end

-- Run a real split command. Drops the pads first so the split gets the
-- full width; once it's the only window left again, the pads come back.
function M.split(cmd)
  local was_enabled = state ~= nil
  if was_enabled then off() end
  vim.cmd(cmd)
  if was_enabled then
    if #vim.api.nvim_list_wins() > 1 then
      awaiting_reenable = true
    else
      on()
    end
  end
end

-- On by default. Deferred to UIEnter (fires after VimEnter for the builtin
-- TUI) so it runs after snacks' dashboard has had a chance to open -- the
-- dashboard refuses to open unless there's exactly one window.
vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = on,
})

-- Keep side windows out of the way: skip entering them, resize them on
-- terminal resize, and drop state if the user closes one manually.
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    if not state then return end
    local win = vim.api.nvim_get_current_win()
    if win == state.left or win == state.right then
      vim.api.nvim_set_current_win(state.main)
    end
  end,
})

vim.api.nvim_create_autocmd("WinClosed", {
  callback = function(ev)
    if not state then return end
    local win = tonumber(ev.match)
    if win == state.main then
      -- Main window closed (e.g. :q): close the pads too, on the next tick
      -- since windows can't be closed from inside a WinClosed callback.
      -- With no windows left this quits Neovim, so a single :q is enough.
      local left, right = state.left, state.right
      state = nil
      vim.schedule(function()
        -- 'hidden' (on by default) lets :q close main's window even with
        -- unsaved changes -- it just hides the buffer instead of erroring.
        -- Ask up front, the same way :qall would, instead of silently
        -- closing pads first and only hitting the real check once we'd
        -- reach the truly-last window.
        if #vim.fn.getbufinfo({ bufmodified = 1 }) > 0 then
          vim.cmd("confirm qall")
          return
        end

        -- nvim_win_close() refuses to close the last window (E444); :quit
        -- on the last window just exits Neovim like a normal quit would.
        for _, win in ipairs({ left, right }) do
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_set_current_win(win)
            vim.cmd("quit")
          end
        end
      end)
    elseif win == state.left or win == state.right then
      state = nil
    end
  end,
})

-- A real split (opened via M.split) just closed: re-pad if it was the
-- last extra window. Deferred for the same reason as above.
vim.api.nvim_create_autocmd("WinClosed", {
  callback = function()
    if not awaiting_reenable then return end
    vim.schedule(function()
      if awaiting_reenable and not state and #vim.api.nvim_list_wins() == 1 then
        awaiting_reenable = false
        on()
      end
    end)
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    if not state then return end
    local pad = math.floor((vim.o.columns - width) / 2)
    if pad <= 0 then return end
    if vim.api.nvim_win_is_valid(state.left) then vim.api.nvim_win_set_width(state.left, pad) end
    if vim.api.nvim_win_is_valid(state.right) then vim.api.nvim_win_set_width(state.right, pad) end
  end,
})

return M
