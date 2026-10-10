local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({})
pcall(telescope.load_extension, "fzf") -- native sorter, ignore if not built yet

local map = vim.keymap.set
map("n", "<leader>ff", builtin.find_files, { desc = "Files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Help" })
map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
