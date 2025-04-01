-- CSS configuration
return {
  -- CSS LSP setup
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        -- CSS Language Server
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = 'ignore', -- Helps with TailwindCSS and other CSS frameworks
              },
            },
            scss = {
              validate = true,
              lint = {
                unknownAtRules = 'ignore',
              },
            },
          },
        },
        -- Tailwind CSS Language Server (if you use TailwindCSS)
        tailwindcss = {
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  'tw\\(([^)]*)\\)',
                  'tw`([^`]*)',
                  'className="([^"]*)',
                  'class="([^"]*)',
                  'classes="([^"]*)',
                },
              },
            },
          },
        },
      },
    },
  },

  -- Mason setup to ensure CSS tools are installed
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        'css-lsp',
        'tailwindcss-language-server',
        'stylelint-lsp',
        'prettier',
      })
    end,
  },

  -- Tailwind CSS intellisense
  {
    'roobert/tailwindcss-colorizer-cmp.nvim',
    ft = { 'css', 'scss', 'html' },
    dependencies = {
      'nvim-cmp',
      'NvChad/nvim-colorizer.lua',
    },
    config = true,
  },

  -- CSS color highlighting
  {
    'norcalli/nvim-colorizer.lua',
    ft = { 'css', 'scss', 'html' },
    config = function()
      require('colorizer').setup {
        css = { css = true, css_fn = true },
        scss = { css = true, css_fn = true },
        html = { css = true },
      }
    end,
  },

  -- Setup conform for CSS formatting
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = {
      formatters_by_ft = {
        css = { 'prettier' },
        scss = { 'prettier' },
      },
    },
  },

  -- Setup nvim-lint for CSS linting
  {
    'mfussenegger/nvim-lint',
    optional = true,
    opts = {
      linters_by_ft = {
        css = { 'stylelint' },
        scss = { 'stylelint' },
      },
    },
  },

  -- TreeSitter for better syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'css', 'scss' })
      end
    end,
  },

  -- CSS specific key mappings
  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      -- CSS specific mappings
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'css', 'scss' },
        callback = function()
          vim.keymap.set('n', '<leader>cp', ':%!prettier --parser css<CR>', { desc = 'Format CSS with Prettier', buffer = true })
          vim.keymap.set('n', '<leader>cs', '/\\.*{<CR>', { desc = 'Find next CSS selector', buffer = true })
        end,
      })
    end,
  },
}
