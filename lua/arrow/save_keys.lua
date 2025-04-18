local M = {}

function M.cwd()
	return vim.loop.cwd()
end

function M.git_root()
	local git_files = vim.fs.find(".git", { upward = true, stop = vim.loop.os_homedir() })
	if git_files then
		local result = vim.fn.system({ "git", "rev-parse", "--show-toplevel" })
		result = vim.trim(string.gsub(result, "\n", ""))
		if vim.fn.has("win32") == 1 then
			result = result:gsub("/", "\\")
		end
		return result
	else
		return M.cwd()
	end
end

function M.git_root_bare()
	local git_bare_root = vim.fn.system("git rev-parse --path-format=absolute --git-common-dir 2>&1")
	if vim.v.shell_error == 0 then
		git_bare_root = git_bare_root:gsub("/%.git\n$", "")
		git_bare_root = git_bare_root:gsub("\n$", "")
		if vim.fn.has("win32") == 1 then
			git_bare_root = git_bare_root:gsub("/", "\\")
		end
		return git_bare_root
	end
	return M.cwd()
end

return M
