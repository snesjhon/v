vim.keymap.set("n", "-", function() require("configs.zen").split("vsplit") end, { desc = "Vertical split" })
vim.keymap.set("n", "<leader>z", function() require("configs.zen").toggle() end, { desc = "Toggle zen mode" })
vim.keymap.set("n", "<leader>ut", function() require("configs.theme").toggle() end, { desc = "Toggle light/dark theme" })
vim.keymap.set("n", ",", "<cmd>:bprev<CR>", { desc = "prev" })
vim.keymap.set("n", ".", "<cmd>:bnext<CR>", { desc = "next" })
vim.keymap.set("n", "<C-S-w>", "<cmd>bp<bar>bd #<CR>", { desc = "Close buffer" })

vim.keymap.set("n", "<leader>s", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<F10>", "<cmd>w<CR>", { desc = "Save file" })


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
vim.keymap.set("n", "<leader>gs", function() require("snacks").picker.git_status() end, { desc = "Git status" })
vim.keymap.set("n", "<leader>gT", function() require("snacks").picker.git_stash() end, { desc = "Git stash" })
vim.keymap.set("n", "<leader>gg", function() require("configs.lazygit").toggle() end, { desc = "LazyGit" })


-- LSP keymaps -----------------------------------------------------------
-- Buffer-local, only set once a language server actually attaches, so they
-- stay inert on buffers with no LSP client.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", function() require("snacks").picker.lsp_references() end, opts)
    vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
    -- native hover() focuses an already-open float on a second call; defer a
    -- second call so `gl` opens-and-focuses in one keypress instead of two.
    vim.keymap.set("n", "gl", function()
      vim.lsp.buf.hover()
      vim.defer_fn(vim.lsp.buf.hover, 50)
    end, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gf", function() vim.lsp.buf.format { async = true } end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.jump { count = 1, float = true } end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.jump { count = -1, float = true } end, opts)
    vim.keymap.set("n", "<leader>d", function() require("snacks").picker.diagnostics_buffer() end, opts)
    vim.keymap.set("n", "<leader>lD", function() require("snacks").picker.diagnostics() end, opts)
    vim.keymap.set("n", "<leader>ls", function() require("snacks").picker.lsp_symbols() end, opts)
    -- Insert-mode <C-Space> is handled by blink.cmp's own "default" keymap
    -- preset (lua/configs/blink.lua); only the normal-mode entry point lives
    -- here since it needs the diagnostic-float fallback.
    vim.keymap.set("n", "<C-Space>", function()
      local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
      if #vim.diagnostic.get(0, { lnum = lnum }) > 0 then
        vim.diagnostic.open_float()
        return
      end
      vim.cmd("startinsert!") -- append, not insert -- keeps the cursor after the current char
      require("blink.cmp").show()
    end, opts)
  end,
})
