# Neovim Configuration

Leader key: **Space**

## General Mappings (`lua/nazri/remap.lua`)

| Key | Mode | Action |
|---|---|---|
| `<leader>pv` | n | Open file explorer (`:Ex`) |
| `J` | v | Move selected lines down |
| `K` | v | Move selected lines up |
| `n` | n | Next search result, center cursor |
| `N` | n | Previous search result, center cursor |
| `<leader>y` | n | Yank line to system clipboard |
| `<leader>y` | v | Yank selection to system clipboard |

## Telescope (`after/plugin/telescope.lua`)

| Key | Mode | Action |
|---|---|---|
| `<leader>ff` | n | Find files |
| `<leader>fg` | n | Live grep |
| `<leader>fb` | n | List open buffers |
| `<leader>fh` | n | Search help tags |
| `<leader>fs` | n | Live grep (duplicate of fg) |
| `<C-p>` | n | Find git-tracked files |

## Harpoon (`lua/nazri/plugins.lua`)

| Key | Mode | Action |
|---|---|---|
| `<leader>a` | n | Add file to Harpoon list |
| `<C-e>` | n | Toggle Harpoon quick menu |
| `<C-h>` | n | Jump to Harpoon file 1 |
| `<C-t>` | n | Jump to Harpoon file 2 |
| `<C-n>` | n | Jump to Harpoon file 3 |
| `<C-s>` | n | Jump to Harpoon file 4 |

## Git (`lua/nazri/plugins.lua`)

| Key | Mode | Action |
|---|---|---|
| `<leader>gs` | n | Open Git status (fugitive) |

## LSP (`lua/nazri/lsp.lua`)

Buffer-local mappings (active when LSP server is attached):

| Key | Mode | Action |
|---|---|---|
| `K` | n | Show hover documentation |
| `gd` | n | Go to definition |
| `gr` | n | List references |
| `<leader>ca` | n | Code action |
| `<leader>rn` | n | Rename symbol |
| `<leader>D` | n | Go to type definition |
| `<C-k>` | i | Show function signature help |
| `<leader>e` | n | Show diagnostic in float |
| `[d` | n | Previous diagnostic |
| `]d` | n | Next diagnostic |

## Completion (nvim-cmp)

| Key | Mode | Action |
|---|---|---|
| `<C-b>` | i | Scroll docs up |
| `<C-f>` | i | Scroll docs down |
| `<C-Space>` | i | Trigger completion |
| `<C-e>` | i | Cancel completion |
| `<CR>` | i | Confirm completion |

## Autocommands

| Event | Pattern | Action |
|---|---|---|
| `BufWritePre` | `*.go` | Auto-organize imports and format on save |
