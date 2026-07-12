-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

 -- Telescope requires plenary
  use {
    'nvim-telescope/telescope.nvim',
    tag='0.1.8',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      require('telescope').setup()
    end
  }

  end)
