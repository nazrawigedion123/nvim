return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()
    end,
  },
  -- lua/plugins/rose-pine.lua
  {
	  "rose-pine/neovim",
	  name = "rose-pine",
	  opts = {
		  styles = {
			  transparency = true, -- Enables built-in background transparency
		  },
	  },
	  config = function()
		  vim.cmd("colorscheme rose-pine")
	  end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "python","c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "tsx", "jsdoc", "html",
        "go", "gomod", "gowork", "rust", "toml",
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon add file" })
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
      vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
      vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
      vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
      vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })
    end,
  },
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git status (fugitive)" })
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright","lua_ls", "gopls", "rust_analyzer", "ts_ls" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "leoluz/nvim-dap-go",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      
      -- Setup DAP UI
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
        },
        layouts = {
          {
            elements = { "scopes", "breakpoints", "stacks", "watches" },
            size = 40,
            position = "left",
          },
          {
            elements = { "repl", "console" },
            size = 15,
            position = "bottom",
          },
        },
      })
      
      -- Setup DAP Go
      require("dap-go").setup({
        delve = {
          output_mode = "remote",
        },
      })
      
      -- Configure DAP for Go
      dap.configurations.go = {
        {
          type = "go",
          name = "Attach",
          mode = "local",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
        {
          type = "go",
          name = "Debug",
          request = "launch",
          program = "${fileDirname}",
          outputMode = "remote",
          env = vim.empty_dict(),
          args = {},
        },
      }

      local function watch_byte_string()
        local expr = vim.fn.input("Byte expression: ")
        if expr == "" then
          return
        end

        local string_expr = string.format("string(%s)", expr)
        dapui.elements.watches.add(string_expr)
        dap.repl.open()
        dap.repl.execute(string_expr)
      end
      
      -- Keymaps for debugging
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue debugging" })
      vim.keymap.set("n", "<leader>dso", dap.step_over, { desc = "Step over" })
      vim.keymap.set("n", "<leader>dsi", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<leader>dsx", dap.step_out, { desc = "Step out" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run last" })
      vim.keymap.set("n", "<leader>dB", watch_byte_string, { desc = "Watch byte slice as string" })
      
      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
