local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = vim.lsp.protocol.make_client_capabilities()
if cmp_ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

local servers = { "lua_ls", "gopls", "rust_analyzer", "ts_ls" }

local on_attach = function(client, bufnr)
  local buf_opts = { buffer = bufnr }
  vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", { desc = "LSP hover" }, buf_opts))
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", { desc = "LSP definition" }, buf_opts))
  vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", { desc = "LSP references" }, buf_opts))
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", { desc = "LSP code action" }, buf_opts))
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", { desc = "LSP rename" }, buf_opts))
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, vim.tbl_extend("force", { desc = "LSP type definition" }, buf_opts))
  vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", { desc = "LSP signature help" }, buf_opts))
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, vim.tbl_extend("force", { desc = "Show diagnostic error" }, buf_opts))
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", { desc = "Previous diagnostic" }, buf_opts))
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", { desc = "Next diagnostic" }, buf_opts))
end

-- Set defaults for all servers and register each server via vim.lsp.config
vim.lsp.config("*", { capabilities = capabilities, on_attach = on_attach })
for _, server in ipairs(servers) do
  local opts = {}
  if server == "gopls" then
    opts = {
      settings = {
        gopls = {
          gofumpt = true,
          analyses = { unusedparams = true },
          staticcheck = true,
        },
      },
    }
  end
  vim.lsp.config(server, opts)
end
vim.lsp.enable(servers)

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- For Go: add missing imports, organize imports, and format before save
local function go_organize_imports_and_format()
  local clients = vim.lsp.get_clients({ bufnr = 0, name = "gopls" })
  if #clients == 0 then
    return
  end

  local client = clients[1]
  local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
  params.context = {
    only = { "source.addMissingImports", "source.organizeImports", "source.fixAll" },
  }

  local ok, results = pcall(vim.lsp.buf_request_sync, 0, "textDocument/codeAction", params, 3000)
  if not ok then
    return
  end

  for _, res in pairs(results or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit)
      elseif r.command then
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end

  vim.lsp.buf.format({ async = false })
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = go_organize_imports_and_format,
})
