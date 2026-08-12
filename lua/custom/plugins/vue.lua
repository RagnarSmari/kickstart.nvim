return {
  {
    'windwp/nvim-ts-autotag',
    ft = { 'vue', 'html' },
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
}
