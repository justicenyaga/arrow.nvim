local M = {}

local config = require("arrow.config")

function M.get_git_branch()
	local git_files = vim.fs.find(".git", { upward = true, stop = vim.loop.os_homedir(), path = vim.loop.cwd() })
	if git_files and #git_files > 0 then
		local result = vim.fn.system({ "git", "rev-parse", "--show-toplevel" })
		if vim.v.shell_error == 0 then
			return vim.trim(string.gsub(result, "\n", ""))
		end
	end
	return nil
end

function M.refresh_git_branch()
	if config.getState("separate_by_branch") then
		local current_branch = config.getState("current_branch")
		local new_branch = M.get_git_branch()
		if current_branch ~= new_branch then
			config.setState("current_branch", new_branch)
			require("arrow.persist").load_cache_file()
		end
	end
	return config.getState("current_branch")
end

return M
