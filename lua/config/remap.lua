-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set(
	"x",
	"<leader>l",
	"<Esc>`<i[<Esc>`>la](<C-r>+)<Esc>",
	{ desc = "Apply markdown [L]ink on current selection" }
)
vim.keymap.set("n", "<leader>l", "viw<Esc>bi[<Esc>ea](<C-r>+)<Esc>", { desc = "Apply markdown [L]ink on current word" })

-- Handy remaps to insert date/time
vim.keymap.set("n", "<leader>dts", ':r! date "+\\%d-\\%m-\\%Y" <CR>', { desc = "Insert current [D]a[t]e ([S]hort)" })
vim.keymap.set(
	"n",
	"<leader>dtl",
	':r! date "+\\%A \\%d, \\%B \\%Y" <CR>',
	{ desc = "Insert current [D]a[t]e ([L]ong)" }
)
vim.keymap.set("n", "<leader>dtt", ':r! date "+\\%H:\\%M:\\%S" <CR>', { desc = "Insert current [D]a[t]e [T]ime" })

-- Diagnostic keymaps
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "]d", ":prev<CR>", { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "[d", ":cnext<CR>", { desc = "Go to next [D]iagnostic message" })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<C-h>", "<C-w><C-Left>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-Right>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-Down>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-Up>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<leader>sb", ":Telescope frecency<CR>", { desc = "[S]earch [B]ookmark files" })

vim.keymap.set("n", "<leader>ts", ":split | terminal<CR>", { desc = "Open terminal in split" })
vim.keymap.set("n", "<leader>tv", ":vsplit | terminal<CR>", { desc = "Open terminal in vertical split" })

vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>", { desc = "Open File Explorer (with Oil)" })

vim.keymap.set("v", "J", ":move '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":move '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
--vim.keymap.set("n", "n", "nzzzv")
--vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over void" })

-- next greatest remap ever : asbjornHaland
-- vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete into void" })

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

-- vim.keymap.set("n", "<leader>qn", ":cnext<CR>", { desc = "Go to next QuickFix" })
-- vim.keymap.set("n", "<leader>qp", ":cprev<CR>", { desc = "Go to prev QuickFix" })

--vim.keymap.set("n", "Q", "<nop>")
--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
--vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
--vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
--vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

--vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make current file executable", silent = true })
vim.keymap.set("n", "<leader>jq", "<cmd>%!jq<CR>", { desc = "Format buffer with jq", silent = true })
