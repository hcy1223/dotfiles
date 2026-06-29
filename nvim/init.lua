--[[
插件速查（精简）
1) mini.statusline：状态栏，开箱即用，无快捷键
2) mini.basics：一组常用基础编辑设置（按 mini.basics 默认项生效）
3) mini.animate：光标移动、滚动等过渡动画
4) mini.cursorword：高亮光标下单词
5) mini.visits：记录访问过的文件
   - <leader>e：选择当前目录访问过的文件
6) mini.ai：增强文本对象
   - vi" / va"：选引号内/含引号
   - ci( / da)：改括号内 / 删含括号对象
7) leap.nvim：快速跳转（已占用 f）
   - Normal/Visual/Operator 模式按 f，输入目标字符后跳转
8) arrow.nvim（仅 CLI Neovim）：
   - 书签/快速跳转；leader_key=';'，buffer_leader_key='m'
   - 具体映射可用 :map ; 和 :map m 查看
9) VSCode Neovim 专用映射：
   - <leader>b：跳转定义
   - <leader>o：在资源管理器显示
   - <leader>r：重命名
10) CLI Neovim 映射：
   - <leader>o：打开 Oil 文件管理器
11) koda.nvim is the theme plugin
]]
-- NOTE: `.luarc.json` is used to fix VSCode LuaLS hint:
-- `Undefined global 'vim'` (by declaring `vim` in diagnostics.globals).

-- Add Mini.nvim
--
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    -- Uncomment next line to use 'stable' branch
    -- '--branch', 'stable',
    'https://github.com/nvim-mini/mini.nvim',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up mini.deps for plugin manager
require('mini.deps').setup({ path = { package = path_package } })

-- Add (UI load)
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later


now(function()
  require('mini.basics').setup()
end)

now(function()
  require('mini.cursorword').setup()
end)

-- operations
later(function()
  require('mini.ai').setup()
end)

now(function()
  local visits = require('mini.visits')
  visits.setup()

  vim.keymap.set('n', '<leader>e', function()
    visits.select_path(vim.fn.getcwd())
  end, { silent = true, desc = 'Select visited file' })
end)

later(function()
  add({
    source = 'xieyonn/spinner.nvim',
  })
  require('spinner').setup()
end)

later(function()
  require('mini.indentscope').setup({
    symbol = '│',
    options = { try_as_border = true },
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function(args)
      local ft = vim.bo[args.buf].filetype
      if ft ~= 'json' and ft ~= 'jsonc' then
        vim.b[args.buf].miniindentscope_disable = true
      end
    end,
  })
end)

-- later(function() require('mini.surround').setup() end)
later(function()
  add({
    source = 'https://codeberg.org/andyg/leap.nvim',
  })
  require('leap').setup({})
  vim.keymap.set({ 'n', 'x', 'o' }, 'f', '<Plug>(leap)')
  vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
end)




-- Fast vertical jumps
vim.keymap.set('n', '<C-j>', '10j', { silent = true })
vim.keymap.set('v', '<C-j>', '10j', { silent = true })
vim.keymap.set('n', '<C-k>', '10k', { silent = true })
vim.keymap.set('v', '<C-k>', '10k', { silent = true })

if vim.g.vscode then
  require('config_vs').setup()
else
  -- neovim cli related
  -- Indentation defaults: 4 spaces globally.
  -- require('vim._core.ui2').enable()
  vim.opt.expandtab = true
  vim.opt.tabstop = 4
  vim.opt.shiftwidth = 4
  vim.opt.softtabstop = 4
  vim.opt.smartindent = true
  vim.opt.shiftround = true
  vim.o.autocomplete = true

  -- Common web/script formats: 2 spaces.
  vim.api.nvim_create_autocmd('FileType', {
    pattern = {
      'lua',
      'javascript',
      'typescript',
      'json',
      'yaml',
      'html',
      'css',
    },
    callback = function()
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.softtabstop = 2
    end,
  })

  -- warp markdown file
  vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.showbreak = "↪ "
  end,
})
  local theme = require('theme')
  theme.install(add, now)
  now(function()
    -- theme.configure()
    -- theme.apply('warm-burnout-light')
  end)

  -- not working with koda
  now(function()
    require('mini.statusline').setup({})
  end)

  now(function()
    add({
      source = 'otavioschwanck/arrow.nvim',
    })
    require('arrow').setup({
      show_icons = true,
      leader_key = ';',        -- Recommended to be a single key
      buffer_leader_key = 'm', -- Per Buffer Mappings
    })
  end)
  later(function()
    add({ source = 'stevearc/oil.nvim' })
    add({ source = 'nvim-tree/nvim-web-devicons' })
    require('oil').setup({})
    vim.keymap.set('n', '<leader>o', '<cmd>Oil<CR>', { silent = true, desc = 'Open Oil' })
  end)
  later(function()
    add({
      source = 'folke/noice.nvim',
    })
    add({ source = 'MunifTanjim/nui.nvim' })
    add({ source = 'rcarriga/nvim-notify' })
    require('noice').setup({
      -- Use popup-style cmdline UI.
      cmdline = {
        view = 'cmdline_popup',
      },
      -- Popup completion menu backend.
      popupmenu = {
        enabled = true,
        backend = 'nui',
      },
      -- Single integrated palette for cmdline + completion.
      presets = {
        command_palette = true,
      },
      views = {
        cmdline_popup = {
          -- Center the popup on screen.
          position = {
            row = '50%',
            col = '50%',
          },
        },
      },
    })
  end)
  -- now(function()
  --   require('mini.sessions').setup()
  -- end)
  now(function()
    require('mini.starter').setup()
  end)
  later(function()
    require('mini.animate').setup()
  end)
end
