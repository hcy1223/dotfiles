local M = {}

function M.install(add, now)
  now(function()
    add({
      source = 'felipefdl/warm-burnout',
    })
    -- warm-burnout stores nvim files in a subdirectory.
    local deps_root = vim.fn.stdpath('data') .. '/site/pack/deps'
    local warm_dir = deps_root .. '/opt/warm-burnout/nvim'
    if vim.fn.isdirectory(warm_dir) == 0 then
      warm_dir = deps_root .. '/start/warm-burnout/nvim'
    end
    if vim.fn.isdirectory(warm_dir) == 1 then
      vim.opt.rtp:append(warm_dir)
    end
  end)

  now(function()
    add({
      source = 'oskarnurm/koda.nvim',
    })
  end)
end

function M.configure()
  require('koda').setup({})
end

function M.apply(name)
  vim.cmd.colorscheme(name or 'koda')
end

return M
