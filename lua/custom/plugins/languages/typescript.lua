-- TypeScript configuration
return {
  -- TypeScript LSP setup
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        -- TypeScript Language Server
        ts_ls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
      },
    },
  },

  -- TypeScript tools and syntax plugins
  {
    'jose-elias-alvarez/typescript.nvim',
    dependencies = { 'nvim-lspconfig' },
    config = function()
      require('typescript').setup {
        server = {
          on_attach = function(client, bufnr)
            -- Disable tsserver formatting if you plan to use prettier/eslint
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false

            -- Enable Go-To Definition, References, etc.
            local opts = { buffer = bufnr, silent = true }
            vim.keymap.set('n', 'gd', '<cmd>TypescriptGoToDefinition<CR>', opts)
            vim.keymap.set('n', 'gr', '<cmd>TypescriptRenameFile<CR>', opts)
            vim.keymap.set('n', 'gi', '<cmd>TypescriptOrganizeImports<CR>', opts)
            vim.keymap.set('n', '<leader>rf', '<cmd>TypescriptRenameFile<CR>', opts)
            vim.keymap.set('n', '<leader>oi', '<cmd>TypescriptOrganizeImports<CR>', opts)
            vim.keymap.set('n', '<leader>ru', '<cmd>TypescriptRemoveUnused<CR>', opts)
            vim.keymap.set('n', '<leader>fa', '<cmd>TypescriptFixAll<CR>', opts)
            vim.keymap.set('n', '<leader>am', '<cmd>TypescriptAddMissingImports<CR>', opts)
          end,
        },
      }
    end,
  },

  -- Mason setup to ensure TypeScript tools are installed
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        'typescript-language-server',
        'eslint-lsp',
        'prettier',
        'prettierd',
        'eslint_d',
      })
    end,
  },

  -- Setup conform for TS formatting
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = {
      formatters_by_ft = {
        typescript = { 'prettierd', 'prettier', 'eslint_d' },
      },
    },
  },

  -- Setup nvim-lint for TS linting
  {
    'mfussenegger/nvim-lint',
    optional = true,
    opts = {
      linters_by_ft = {
        typescript = { 'eslint_d' },
      },
    },
  },

  -- TreeSitter for better syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'typescript', 'tsx' })
      end
    end,
  },
}
