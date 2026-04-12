return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      -- Mason v2 path to vue language server
      local vue_language_server_path = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'

      local vue_plugin = {
        name = '@vue/typescript-plugin',
        location = vue_language_server_path,
        languages = { 'vue' },
        configNamespace = 'typescript',
      }

      vim.lsp.config('ts_ls', {
        init_options = {
          plugins = { vue_plugin },
        },
        filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
      })

      vim.lsp.config('vue_ls', {})

      vim.lsp.enable { 'ts_ls', 'vue_ls' }
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    ft = { 'vue', 'html' },
    config = function() require('nvim-ts-autotag').setup() end,
  },
}
