local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local make_entry = require("telescope.make_entry")

local M = {}

local function read_bookmarks()
	local bookmarks_file = vim.fn.expand("$XDG_CONFIG_HOME/nvim/bookmarks.txt")
	local results = {}

	local f = io.open(bookmarks_file, "r")
	if not f then
		vim.notify("Could not open bookmarks file: " .. bookmarks_file, vim.log.levels.WARN)
		return results
	end

	for line in f:lines() do
		local trimmed = line:match("^%s*(.-)%s*$")
		if trimmed ~= "" then
			table.insert(results, vim.fn.expand(trimmed))
		end
	end

	f:close()
	return results
end

function M.bookmark_files()
	local files = read_bookmarks()

	pickers
		.new({}, {
			prompt_title = "Bookmarks",
			finder = finders.new_table({
				results = files,
				entry_maker = make_entry.gen_from_file({}),
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.file_sorter({}),
		})
		:find()
end

vim.api.nvim_create_user_command("TelescopeBookmarks", M.bookmark_files, { desc = "[S]earch [B]ookmarks" })

vim.keymap.set("n", "<space>sb", M.bookmark_files, { desc = "[S]earch [B]ookmarks" })

return M
