local function rebuild_project(co, path)
	local spinner = require("easy-dotnet.ui-modules.spinner").new()
	spinner:start_spinner("Building")
	vim.fn.jobstart(string.format("dotnet build %s", path), {
		on_exit = function(_, return_code)
			if return_code == 0 then
				spinner:stop_spinner("Built successfully")
			else
				spinner:stop_spinner("Build failed with exit code " .. return_code, vim.log.levels.ERROR)
				error("Build failed")
			end
			coroutine.resume(co)
		end,
	})
	coroutine.yield()
end

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- "leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")

			-- Keymaps for controlling the debugger

			vim.keymap.set("n", "<space>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
			vim.keymap.set("n", "<space>gb", dap.run_to_cursor, { desc = "Run to cursor" })
			vim.keymap.set("n", "dq", function()
				dap.terminate()
				dap.clear_breakpoints()
			end, { desc = "Terminate and clear breakpoints" })

			-- Eval var under cursor
			vim.keymap.set("n", "<space>?", function()
				require("dapui").eval(nil, { enter = true })
			end)

			vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "🚀", texthl = "", linehl = "", numhl = "" })

			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/continue debugging" })
			vim.keymap.set("n", "<F7>", dap.step_into, { desc = "Step into" })
			vim.keymap.set("n", "<F8>", dap.step_over, { desc = "Step over" })
			vim.keymap.set("n", "<F9>", dap.step_out, { desc = "Step out" })
			vim.keymap.set("n", "<F10>", dap.restart, { desc = "Restart" })

			-- local dotnet = require("config.custom.nvim-dap-dotnet")

			-- .NET specific setup using `easy-dotnet`
			require("easy-dotnet.netcoredbg").register_dap_variables_viewer() -- special variables viewer specific for .NET
			local dotnet = require("easy-dotnet")
			local debug_dll = nil

			local function ensure_dll()
				if debug_dll ~= nil then
					return debug_dll
				end
				local dll = dotnet.get_debug_dll(true)
				debug_dll = dll
				return dll
			end

			for _, value in ipairs({ "cs", "fsharp" }) do
				dap.configurations[value] = {
					{
						type = "coreclr",
						name = "Program",
						request = "launch",
						env = function()
							local dll = ensure_dll()
							local vars = dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)
							return vars or nil
						end,
						program = function()
							local dll = ensure_dll()
							print(dll)
							local co = coroutine.running()
							rebuild_project(co, dll.project_path)
							return dll.relative_dll_path
						end,
						cwd = function()
							local dll = ensure_dll()
							return dll.relative_project_path
						end,
					},
					{
						type = "coreclr",
						name = "Test",
						request = "attach",
						processId = function()
							local res = require("easy-dotnet").experimental.start_debugging_test_project()
							return res.process_id
						end,
					},
				}
			end

			-- Reset debug_dll after each terminated session
			dap.listeners.before["event_terminated"]["easy-dotnet"] = function()
				debug_dll = nil
			end

			dap.adapters.coreclr = {
				type = "executable",
				command = "netcoredbg",
				args = {
					"--interpreter=vscode",
					"--engineLogging=/home/coco/Workspace/work/config/dap-engine.log",
					"--log=file",
				},
			}

			local dapui = require("dapui")
			require("dapui").setup()

			-- dap.configurations.cs = {
			-- 	{
			-- 		type = "coreclr",
			-- 		name = "launch-netcoredbg",
			-- 		request = "launch",
			-- 		program = function()
			-- 			return dotnet.build_dll_path()
			-- 		end,
			-- 		cwd = vim.fn.getcwd(),
			-- 		env = {
			-- 			ASPNETCORE_ENVIRONMENT = "Development",
			-- 			DOTNET_ENVIRONMENT = "Development",
			-- 		},
			-- 		args = {
			-- 			"--urls=http://localhost:5152",
			-- 			"--environment=Development",
			-- 		},
			-- 		console = "integratedTerminal",
			-- 	},
			-- 	{
			-- 		type = "coreclr",
			-- 		name = "attach-netcoredbg",
			-- 		request = "attach",
			-- 		processId = require("dap.utils").pick_process,
			-- 	},
			-- }

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
}
