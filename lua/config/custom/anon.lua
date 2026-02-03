local M = {}

local function nocase(s)
	return (s:gsub("%a", function(c)
		return string.format("[%s%s]", string.lower(c), string.upper(c))
	end))
end

local function load_pairs_from_csv(path)
	local pairs = {}
	local f = io.open(path, "r")
	if not f then
		vim.notify("Cannot open CSV: " .. path, vim.log.levels.ERROR)
		return pairs
	end

	local first_line = true
	for line in f:lines() do
		-- skip header line
		if first_line then
			first_line = false
		else
			-- simple CSV: from,to (no quotes/commas inside fields)
			local from, to = line:match("^([^,]+),([^,]+)$")
			if from and to then
				table.insert(pairs, { from = from, to = to })
			end
		end
	end

	f:close()
	return pairs
end

local secret_terms_csv_path = vim.fn.stdpath("config") .. "/secret_terms.csv"

function M.anonymize_file()
	local replace_pairs = load_pairs_from_csv(secret_terms_csv_path)

	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	for i, line in ipairs(lines) do
		for _, pair in ipairs(replace_pairs) do
			line = line:gsub(nocase(pair.from), pair.to)
		end
		lines[i] = line
	end

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

vim.api.nvim_create_user_command("Anon", M.anonymize_file, { desc = "Anonymize current file" })

return M
