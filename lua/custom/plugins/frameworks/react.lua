-- React configuration
return {
  -- React LSP and tools setup
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        -- Configure ts_ls with React-specific settings
        ts_ls = {
          settings = {
            typescript = {
              -- Enable React specific features
              suggestionActions = { enabled = true },
              updateImportsOnFileMove = { enabled = 'always' },
              preferences = {
                importModuleSpecifierPreference = 'relative',
              },
            },
          },
          -- Optional: Link React snippets here
          -- init_options = {
          --   preferences = {
          --     includeCompletionsWithSnippetText = true,
          --     includeCompletionsWithClassMember = true,
          --   },
          -- },
        },
      },
    },
  },

  -- Mason setup to ensure React tools are installed
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        'css-lsp', -- CSS language server
        'html-lsp', -- HTML language server
        'tailwindcss-language-server', -- For Tailwind CSS
        'stylelint-lsp', -- For CSS/SCSS linting
      })
    end,
  },

  -- TreeSitter config for JSX/TSX support
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'tsx', 'javascript', 'typescript', 'css', 'html' })
      end
    end,
  },

  -- Add JSX/TSX specific capabilities to cmp
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      { 'roobert/tailwindcss-colorizer-cmp.nvim', config = true },
    },
    opts = function(_, opts)
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        format_kinds(entry, item)
        return require('tailwindcss-colorizer-cmp').formatter(entry, item)
      end
    end,
  },

  -- Specific React snippets
  {
    'L3MON4D3/LuaSnip',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load { paths = { './snippets/react' } }
    end,
  },

  -- Setup conform for React formatting
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = {
      formatters_by_ft = {
        typescriptreact = { 'prettierd', 'prettier', 'eslint_d' },
        javascriptreact = { 'prettierd', 'prettier', 'eslint_d' },
      },
    },
  },

  -- Setup nvim-lint for React linting
  {
    'mfussenegger/nvim-lint',
    optional = true,
    opts = {
      linters_by_ft = {
        typescriptreact = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
      },
    },
  },

  -- React specific key mappings and utilities
  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      -- React specific mappings
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'typescriptreact', 'javascriptreact' },
        callback = function()
          -- React mappings
          vim.keymap.set('n', '<leader>rc', 'yiwoconsole.log(\'<C-r>":\', <C-r>")<Esc>', { desc = 'Console log word', buffer = true })
          vim.keymap.set('v', '<leader>rc', "yoconsole.log('<Esc>pa:', <Esc>pa)<Esc>", { desc = 'Console log selection', buffer = true })
          vim.keymap.set('n', '<leader>ri', ':TypescriptAddMissingImports<CR>', { desc = 'Add missing imports', buffer = true })
          vim.keymap.set('n', '<leader>ro', ':TypescriptOrganizeImports<CR>', { desc = 'Organize imports', buffer = true })
          vim.keymap.set('n', '<leader>rf', ':TypescriptFixAll<CR>', { desc = 'Fix all TypeScript errors', buffer = true })
          vim.keymap.set('n', '<leader>rr', ':TypescriptRenameFile<CR>', { desc = 'Rename file and update imports', buffer = true })
        end,
      })
    end,
  },

  -- Better tag matching for JSX
  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    config = true,
  },

  -- Improved JSX comments (/** */ style)
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    event = 'VeryLazy',
    config = function()
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }
    end,
  },

  -- React component folding
  {
    'jghauser/fold-cycle.nvim',
    event = 'BufReadPost',
    config = function()
      require('fold-cycle').setup {
        open_if_max_closed = true,
        close_if_max_opened = true,
        softwrap_movement_fix = true,
      }

      vim.keymap.set('n', '<tab>', function()
        require('fold-cycle').open()
      end, { desc = 'Open fold' })
      vim.keymap.set('n', '<s-tab>', function()
        require('fold-cycle').close()
      end, { desc = 'Close fold' })
      vim.keymap.set('n', '<leader>z', function()
        require('fold-cycle').toggle_all()
      end, { desc = 'Toggle all folds' })
    end,
  },

  -- Improved parentheses/brackets for JSX
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      check_ts = true,
      ts_config = {
        javascript = { 'template_string' },
        typescript = { 'template_string' },
        javascriptreact = { 'template_string' },
        typescriptreact = { 'template_string' },
      },
    },
  },

  -- Enhanced React debugging support
  {
    'mxsdev/nvim-dap-vscode-js',
    ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    dependencies = {
      'mfussenegger/nvim-dap',
      {
        'microsoft/vscode-js-debug',
        build = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out',
      },
    },
    config = function()
      require('dap-vscode-js').setup {
        debugger_path = vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug',
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
      }

      for _, language in ipairs { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' } do
        require('dap').configurations[language] = {
          -- Node.js
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch file',
            program = '${file}',
            cwd = '${workspaceFolder}',
          },
          -- Jest
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Debug Jest Tests',
            runtimeExecutable = 'node',
            runtimeArgs = {
              './node_modules/jest/bin/jest.js',
              '--runInBand',
            },
            rootPath = '${workspaceFolder}',
            cwd = '${workspaceFolder}',
            console = 'integratedTerminal',
            internalConsoleOptions = 'neverOpen',
          },
          -- Chrome/React
          {
            type = 'pwa-chrome',
            request = 'launch',
            name = 'Launch Chrome against localhost',
            url = 'http://localhost:3000',
            webRoot = '${workspaceFolder}',
            userDataDir = '${workspaceFolder}/.vscode/chrome-debug-profile',
          },
        }
      end
    end,
  },
}
