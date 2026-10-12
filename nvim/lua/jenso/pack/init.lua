-- Build hooks must be registered BEFORE vim.pack.add()
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
			vim.system({ "make" }, { cwd = ev.data.path }):wait()
		end
		if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({
	-- Colorscheme
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },

	-- UI
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/folke/which-key.nvim",

	-- Finder
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",

	-- Syntax
	"https://github.com/nvim-treesitter/nvim-treesitter",

	-- Navigation
	"https://github.com/christoomey/vim-tmux-navigator",

	-- Git
	"https://github.com/lewis6991/gitsigns.nvim",
})

require("jenso.pack.colorscheme")
require("jenso.pack.lualine")
require("jenso.pack.which-key")
require("jenso.pack.telescope")
require("jenso.pack.treesitter")
require("jenso.pack.tmux-navigator")
require("jenso.pack.gitsigns")
