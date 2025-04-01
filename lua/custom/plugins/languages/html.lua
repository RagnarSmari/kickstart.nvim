-- HTML configuration
return {
  -- HTML LSP setup
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        -- HTML Language Server
        html = {
          settings = {
            html = {
              format = {
                wrapLineLength = 120,
                endWithNewline = true,
                wrapAttributes = 'auto',
              },
              hover = {
                documentation = true,
                references = true,
              },
            },
          },
        },
      },
    },
  },

  -- Mason setup to ensure HTML tools are installed
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        'html-lsp',
        'emmet-ls',
        'prettier',
      })
    end,
  },

  -- Emmet support
  {
    'mattn/emmet-vim',
    ft = { 'html', 'css' },
  },

  -- HTML tag autoclosing
  {
    'windwp/nvim-ts-autotag',
    ft = { 'html' },
    config = function()
      require('nvim-ts-autotag').setup {
        filetypes = { 'html' },
      }
    end,
  },

  -- Setup conform for HTML formatting
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = {
      formatters_by_ft = {
        html = { 'prettier' },
      },
    },
  },

  -- TreeSitter for better syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'html' })
      end
    end,
  },

  -- HTML specific key mappings
  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      -- HTML specific mappings
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'html' },
        callback = function()
          vim.keymap.set('n', '<leader>hp', ':%!prettier --parser html<CR>', { desc = 'Format HTML with Prettier', buffer = true })
          vim.keymap.set('n', '<leader>ht', 'vit', { desc = 'Select inside tag', buffer = true })
          vim.keymap.set('n', '<leader>hat', 'vat', { desc = 'Select around tag', buffer = true })
        end,
      })
    end,
  },
}
