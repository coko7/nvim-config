require("config")

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("config-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Hyprlang LSP
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.hl", "hypr*.conf" },
	callback = function(event)
		print(string.format("starting hyprls for %s", vim.inspect(event)))
		vim.lsp.start({
			name = "hyprlang",
			cmd = { "hyprls" },
			root_dir = vim.fn.getcwd(),
		})
	end,
})

vim.api.nvim_create_user_command("MyTodo", function()
	local current_file = vim.api.nvim_buf_get_name(0)
	if current_file == "" then
		print("No file name for current buffer")
		return
	end

	local sl_file_path = vim.fn.resolve(current_file)
	local file_name = sl_file_path:match("([^\\/]+)$")
	print(file_name)
end, {})

vim.api.nvim_create_user_command("Shebang", function()
	vim.api.nvim_put({ "#!/usr/bin/env bash", "" }, "l", false, true)
end, {})

require("mason").setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
})

vim.filetype.add({
	extension = {
		wxs = "xml",
		rasi = "rasi",
	},
	pattern = {
		[".*/waybar/config"] = "jsonc",
		[".*/kitty/*.conf"] = "bash",
		[".*/hypr/.*%.conf"] = "hyprlang",
	},
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.appsettings*.json",
	callback = function()
		vim.bo.filetype = "jsonc"
	end,
})

function LineNumberColors()
	vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "gray", bold = false })
	vim.api.nvim_set_hl(0, "LineNr", { fg = "#ffe5b4", bold = true })
	vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "gray", bold = false })
end

LineNumberColors()

-- vim.filetype.add({
-- 	extension = { ruleset = "xml" },
-- })
