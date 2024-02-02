-- Stores LSP functions to be called when a new LSP client attaches
-- to a buffer. This allows arbitrary plugins to register with LSP
-- clients without the need to interact with the inner workings of
-- the plugin manager.

local M = {}

---@type (fun(client:lsp.Client,bufnr:number):nil)[]
local on_attach_funcs = {}

---@param func fun(client:lsp.Client,bufnr:number):nil
function M.add_on_attach(func)
    table.insert(on_attach_funcs, func)
end

---@param client lsp.Client
---@param bufnr number
function M.on_attach(client, bufnr)
    for _, func in pairs(on_attach_funcs) do
        func(client, bufnr)
    end
end

return M
