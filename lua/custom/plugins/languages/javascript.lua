-- JavaScript configuration
return {
  -- JavaScript LSP setup
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        -- Set up ESLint as language server
        eslint = {
          settings = {
            -- JavaScript specific settings
            workingDirectory = { mode = 'auto' },
            format = true,
            autoFixOnSave = true,
          },
        },
      },
    },
  },

  -- Mason setup to ensure JavaScript tools are installed
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        'eslint-lsp',
        'prettier',
        'prettierd',
        'eslint_d',
        'js-debug-adapter', -- For debugging JavaScript
      })
    end,
  },

  -- Setup conform for JS formatting
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = {
      formatters_by_ft = {
        javascript = { 'prettierd', 'prettier', 'eslint_d' },
      },
    },
  },

  -- Setup nvim-lint for JS linting
  {
    'mfussenegger/nvim-lint',
    optional = true,
    opts = {
      linters_by_ft = {
        javascript = { 'eslint_d' },
      },
    },
  },

  -- TreeSitter for better syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'javascript' })
      end
    end,
  },

  -- JavaScript specific key mappings
  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      -- JavaScript specific mappings
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'javascript' },
        callback = function()
          -- Local file navigation and utilities
          vim.keymap.set('n', '<leader>ji', ':EslintFixAll<CR>', { desc = 'Fix all ESLint issues', buffer = true })
          vim.keymap.set('n', '<leader>jf', ':FormatWrite<CR>', { desc = 'Format JavaScript', buffer = true })
          vim.keymap.set('n', '<leader>jc', 'yiwoconsole.log(\'<C-r>":\', <C-r>")<Esc>', { desc = 'Console log word', buffer = true })
          vim.keymap.set('v', '<leader>jc', "yoconsole.log('<Esc>pa:', <Esc>pa)<Esc>", { desc = 'Console log selection', buffer = true })
        end,
      })
    end,
  },

  -- Debug adapter for JavaScript
  -- {
  --   'mxsdev/nvim-dap-vscode-js',
  --   ft = { 'javascript' },
  --   dependencies = {
  --     'mfussenegger/nvim-dap',
  --     {
  --       'microsoft/vscode-js-debug',
  --       build = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out',
  --     },
  --   },
  --   config = function()
  --     require('dap-vscode-js').setup {
  --       debugger_path = vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug',
  --       adapters = { 'pwa-node' },
  --     }
  --
  --     require('dap').configurations.javascript = {
  --       -- Node.js
  --       {
  --         type = 'pwa-node',
  --         request = 'launch',
  --         name = 'Launch file',
  --         program = '${file}',
  --         cwd = '${workspaceFolder}',
  --       },
  --       -- Jest
  --       {
  --         type = 'pwa-node',
  --         request = 'launch',
  --         name = 'Debug Jest Tests',
  --         runtimeExecutable = 'node',
  --         runtimeArgs = {
  --           './node_modules/jest/bin/jest.js',
  --           '--runInBand',
  --         },
  --         rootPath = '${workspaceFolder}',
  --         cwd = '${workspaceFolder}',
  --         console = 'integratedTerminal',
  --         internalConsoleOptions = 'neverOpen',
  --       },
  --     }
  --   end,
  -- },
}
