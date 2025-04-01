-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- toggleterm
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        open_mapping = [[<leader>te]], -- Keymapping to toggle terminal
        size = 20, -- Terminal size
        shade_filetypes = { 'terminal' }, -- Shade the terminal window
      }
    end,
  },

  require 'custom.plugins.frameworks.react',
  require 'custom.plugins.languages.javascript',
  require 'custom.plugins.languages.typescript',
  require 'custom.plugins.languages.html',
  require 'custom.plugins.languages.css',
}
