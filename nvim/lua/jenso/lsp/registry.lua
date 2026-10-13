local M = {}

-- LSP server names (as named in nvim-lspconfig). Add python/ts servers later.
M.servers = { "gopls" }

-- Mason packages to keep installed (names differ from server names sometimes)
M.tools = { "gopls", "gofumpt", "delve" }

return M
