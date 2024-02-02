local M = {}

local uname = vim.loop.os_uname()

M.OS = uname.sysname
M.IS_MAC = M.OS == "Darwin"
M.IS_LINUX = M.OS == "Linux"
M.IS_WINDOWS = M.OS:find("Windows") and true or false
M.IS_WSL = M.IS_LINUX and uname.release:find("Microsoft") and true or false

return M
