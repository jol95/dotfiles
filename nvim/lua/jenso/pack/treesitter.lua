-- Parsers to install (async; already-installed ones are skipped)
require("nvim-treesitter").install({
	"lua", "vim", "vimdoc", "query",
	"markdown", "markdown_inline", "bash",
	"go", "gomod", "gosum", "gowork",
	"python",
	"javascript", "typescript", "tsx",
	"json", "yaml", "toml", "html", "css",
})

-- Neovim does the highlighting; we just switch it on per filetype.
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"lua", "vim", "help", "query", "markdown", "sh", "bash",
		"go", "gomod", "gosum", "gowork", "python",
		"javascript", "javascriptreact", "typescript", "typescriptreact",
		"json", "yaml", "toml", "html", "css",
	},
	callback = function()
		pcall(vim.treesitter.start) -- parser may still be installing on first run
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
