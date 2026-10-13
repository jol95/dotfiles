local M = {}

function M.setup()
	vim.lsp.config("gopls", {
		settings = {
			gopls = {
				gofumpt = true, -- format with gofumpt rules
				staticcheck = true,
				analyses = { unusedparams = true, shadow = true },
			},
		},
	})
	vim.lsp.enable("gopls")
end

return M
