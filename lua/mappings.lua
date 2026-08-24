vim.keymap.set("n", "<leader>[", function() require("configs.zen").split("vsplit") end, { desc = "Vertical split" })
vim.keymap.set("n", "<leader>z", function() require("configs.zen").toggle() end, { desc = "Toggle zen mode" })
vim.keymap.set("n", "<leader>ut", function() require("configs.theme").toggle() end, { desc = "Toggle light/dark theme" })
vim.keymap.set("n", ",", "<cmd>:bprev<CR>", { desc = "prev" })
vim.keymap.set("n", ".", "<cmd>:bnext<CR>", { desc = "next" })


-- Search (Snacks picker) --------------------------------------------------
-- Mirrors AstroNvim's Snacks picker keymaps.
vim.keymap.set("n", "<leader>f<CR>", function() require("snacks").picker.resume() end, { desc = "Resume last search" })
vim.keymap.set("n", "<leader>f'", function() require("snacks").picker.marks() end, { desc = "Find marks" })
vim.keymap.set("n", "<leader>fa", function() require("snacks").picker.files({ dirs = { vim.fn.stdpath("config") } }) end, { desc = "Find config files" })
vim.keymap.set("n", "<leader>fb", function() require("snacks").picker.buffers() end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fc", function() require("snacks").picker.grep_word() end, { desc = "Find word under cursor" })
vim.keymap.set("n", "<leader>fC", function() require("snacks").picker.commands() end, { desc = "Find commands" })
vim.keymap.set("n", "<leader>ff", function() require("snacks").picker.files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fF", function() require("snacks").picker.files({ hidden = true, ignored = true }) end, { desc = "Find all files" })
vim.keymap.set("n", "<leader>fg", function() require("snacks").picker.git_files() end, { desc = "Find git files" })
vim.keymap.set("n", "<leader>fh", function() require("snacks").picker.help() end, { desc = "Find help" })
vim.keymap.set("n", "<leader>fk", function() require("snacks").picker.keymaps() end, { desc = "Find keymaps" })
vim.keymap.set("n", "<leader>fl", function() require("snacks").picker.lines() end, { desc = "Find lines" })
vim.keymap.set("n", "<leader>fm", function() require("snacks").picker.man() end, { desc = "Find man pages" })
vim.keymap.set("n", "<leader>fn", function() require("snacks").picker.notifications() end, { desc = "Find notifications" })
vim.keymap.set("n", "<leader>fo", function() require("snacks").picker.recent() end, { desc = "Find old files" })
vim.keymap.set("n", "<leader>fO", function() require("snacks").picker.recent({ filter = { cwd = true } }) end, { desc = "Find old files (cwd)" })
vim.keymap.set("n", "<leader>fp", function() require("snacks").picker.projects() end, { desc = "Find projects" })
vim.keymap.set("n", "<leader>fr", function() require("snacks").picker.registers() end, { desc = "Find registers" })
vim.keymap.set("n", "<leader>fs", function() require("snacks").picker.smart() end, { desc = "Find buffers/recent/files" })
vim.keymap.set("n", "<leader>ft", function() require("snacks").picker.colorschemes() end, { desc = "Find themes" })
vim.keymap.set("n", "<leader>fu", function() require("snacks").picker.undo() end, { desc = "Find undo history" })
vim.keymap.set("n", "<leader>fw", function() require("snacks").picker.grep() end, { desc = "Find words" })
vim.keymap.set("n", "<leader>fW", function() require("snacks").picker.grep({ hidden = true, ignored = true }) end, { desc = "Find words in all files" })


-- Git (Snacks picker) -------------------------------------------------------
vim.keymap.set("n", "<leader>go", function() require("snacks").gitbrowse() end, { desc = "Git browse (open)" })
vim.keymap.set("n", "<leader>gb", function() require("snacks").picker.git_branches() end, { desc = "Git branches" })
vim.keymap.set("n", "<leader>gc", function() require("snacks").picker.git_log() end, { desc = "Git commits (repository)" })
vim.keymap.set("n", "<leader>gC", function() require("snacks").picker.git_log({ current_file = true, follow = true }) end, { desc = "Git commits (current file)" })
vim.keymap.set("n", "<leader>gt", function() require("snacks").picker.git_status() end, { desc = "Git status" })
vim.keymap.set("n", "<leader>gT", function() require("snacks").picker.git_stash() end, { desc = "Git stash" })


-- LSP keymaps -----------------------------------------------------------
-- Buffer-local, only set once a language server actually attaches, so they
-- stay inert on buffers with no LSP client.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "grr", function() require("snacks").picker.lsp_references() end, opts)
    vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.jump { count = 1, float = true } end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.jump { count = -1, float = true } end, opts)
    vim.keymap.set("n", "<leader>d", function() require("snacks").picker.diagnostics_buffer() end, opts)
    vim.keymap.set("n", "<leader>lD", function() require("snacks").picker.diagnostics() end, opts)
    vim.keymap.set("n", "<leader>ls", function() require("snacks").picker.lsp_symbols() end, opts)
    vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get, opts)
    vim.keymap.set("n", "<C-Space>", function()
      local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
      if #vim.diagnostic.get(0, { lnum = lnum }) > 0 then
        vim.diagnostic.open_float()
        return
      end
      vim.cmd("startinsert!") -- append, not insert -- keeps the cursor after the current char
      vim.lsp.completion.get()
    end, opts)
  end,
})
