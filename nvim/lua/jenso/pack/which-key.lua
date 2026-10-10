local wk = require("which-key")
wk.setup({ delay = 300 })

-- Names for the groups shown in the popup
wk.add({
	{ "<leader>f", group = "find" },
	{ "<leader>g", group = "git" },
})
