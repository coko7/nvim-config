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
	local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
	if first_line:sub(1, 2) == "#!" then
		return
	end
	vim.api.nvim_buf_set_lines(0, 0, 0, false, { "#!/usr/bin/env bash", "" })
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
		cshtml = "cs",
	},
	pattern = {
		[".*/waybar/config"] = "jsonc",
		[".*/kitty/*.conf"] = "bash",
		[".*/hypr/.*%.conf"] = "hyprlang",
	},
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.vil",
	callback = function()
		vim.bo.filetype = "json"
	end,
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

-- Automatically replace 'NNBSP' by normal space chars when writing buffer
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.cmd([[%s/\%u202f/ /ge]])
-- 	end,
-- })

-- vim.filetype.add({
-- 	extension = { ruleset = "xml" },
-- })
