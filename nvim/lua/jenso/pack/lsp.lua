require("mason").setup()

local registry = require("jenso.lsp.registry")
require("mason-tool-installer").setup({ ensure_installed = registry.tools })

-- A server with its own file in lua/jenso/lsp/<name>.lua gets that config;
-- otherwise it is enabled with lspconfig's defaults.
for _, name in ipairs(registry.servers) do
	local modname = "jenso.lsp." .. name
	local ok, mod = pcall(require, modname)
	if ok then
		mod.setup()
	elseif tostring(mod):find("module '" .. modname .. "' not found", 1, true) then
		vim.lsp.enable(name)
	else
		error(mod) -- a real error inside the custom file: don't hide it
	end
end

-- Keymaps and completion, set up per buffer when a server attaches
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local function map(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
		end
		map("gd", vim.lsp.buf.definition, "Go to definition")
		map("<leader>rn", vim.lsp.buf.rename, "Rename")
		map("<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("<leader>e", vim.diagnostic.open_float, "Line diagnostics")

		-- Neovim's built-in completion popup (blink.cmp can replace it later)
		vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = true })
	end,
})

-- Format Go on save (gopls applies gofumpt rules)
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})
