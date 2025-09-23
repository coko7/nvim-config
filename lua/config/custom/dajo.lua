-- Custom plugin to integrate with my dajo.sh script for daily journal management

local M = {}

local function lookup_current_file_date()
	local filename = vim.api.nvim_buf_get_name(0)
	if filename == nil or filename == "" then
		error("No current file open")
	end

	local date_or_err = vim.fn.system("dajo.sh --lookup " .. filename)
	local exit_code = vim.v.shell_error

	if exit_code ~= 0 then
		error("dajo.sh failed: " .. date_or_err)
	end

	return date_or_err
end

function M.goto_previous_day()
	local file_date = lookup_current_file_date()
	local prev_date = vim.fn.system("date -d '" .. file_date .. " -1 day' '+%Y-%m-%d'")
	local entry_path = vim.fn.system("dajo.sh --create '" .. prev_date .. "'"):gsub("%s+$", ""):match("^[^:]*:(.*)$")
	if entry_path ~= "" then
		vim.cmd("edit " .. entry_path)
	else
		print("No file path returned by script")
	end
end

function M.goto_next_day()
	local file_date = lookup_current_file_date()
	local next_date = vim.fn.system("date -d '" .. file_date .. " +1 day' '+%Y-%m-%d'")
	local entry_path = vim.fn.system("dajo.sh --get '" .. next_date .. "'"):gsub("%s+$", "")

	if entry_path ~= "" and vim.uv.fs_stat(entry_path) ~= nil then
		vim.cmd("edit " .. entry_path)
	else
		print("dajo.sh: already on latest entry")
	end

	-- print("No file path returned by script")
end

function M.open_current_day_entry()
	local entry_path = vim.fn.system("dajo.sh --create"):gsub("%s+$", ""):match("^[^:]*:(.*)$")

	if entry_path ~= "" then
		vim.cmd("edit " .. entry_path)
	else
		print("No file path returned by script")
	end
end

vim.api.nvim_create_user_command("DajoToday", M.open_current_day_entry, {})
vim.api.nvim_create_user_command("DajoPrevious", M.goto_previous_day, {})
vim.api.nvim_create_user_command("DajoNext", M.goto_next_day, {})

vim.keymap.set("n", "<space>jt", M.open_current_day_entry, { desc = "Open [T]oday journal" })
vim.keymap.set("n", "<space>jp", M.goto_previous_day, { desc = "Open journal for [P]revious day" })
vim.keymap.set("n", "<space>jn", M.goto_next_day, { desc = "Open journal for [N]ext day" })

return M
