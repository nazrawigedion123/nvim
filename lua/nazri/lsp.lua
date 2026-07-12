local servers = { "lua_ls", "gopls", "rust_analyzer", "ts_ls" }

vim.lsp.config("*", {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
})

for _, server in ipairs(servers) do
  vim.lsp.config(server, {})
end

vim.lsp.enable(servers)

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP hover" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "LSP references" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP rename" })
vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "LSP type definition" })
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "LSP signature help" })
