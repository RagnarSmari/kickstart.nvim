return {
  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = function()
      require('flutter-tools').setup {
        lsp = {
          color = {
            enabled = true, -- whether or not to highlight color variables
            background = false, -- highlight the background
            foreground = false, -- highlight the foreground
            virtual_text = true, -- show the highlight using virtual text
          },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = 'prompt',
            enableSnippets = true,
          },
        },
        debugger = {
          enabled = true,
          run_via_dap = false, -- use nvim-dap to run flutter apps
        },
        widget_guides = {
          enabled = true,
        },
      }

      -- Set Dart-specific indentation
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'dart',
        callback = function()
          vim.opt_local.tabstop = 2
          vim.opt_local.shiftwidth = 2
          vim.opt_local.softtabstop = 2
          vim.opt_local.expandtab = true
        end,
      })
    end,
  },
}
