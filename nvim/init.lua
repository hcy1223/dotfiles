--[[
插件速查（精简）
1) 通用（CLI + VSCode Neovim）：
   - mini.basics：基础编辑设置；同时设置 <leader> 为空格
   - mini.ai：增强文本对象
   - leap.nvim：快速跳转（已占用 f）
2) VSCode Neovim：
   - 只保留编辑类插件和 VS Code action 映射
   - 不加载 VS Code 已有的 UI/文件/工作区类插件
3) CLI Neovim：
   - mini.statusline：状态栏，开箱即用，无快捷键
   - mini.animate：光标移动、滚动等过渡动画
   - mini.cursorword：高亮光标下单词
   - mini.indentscope：缩进范围提示
   - fff.nvim：frecency 文件搜索和 live grep
   - <leader>e：按 frecency 模糊搜索文件
   - arrow.nvim：书签/快速跳转；leader_key=';'，buffer_leader_key='m'
   - neo-tree.nvim：Git changed files 浮动树
4) VSCode Neovim 专用映射：
   - <leader>b：跳转定义
   - <leader>e：Quick Open
   - <leader>o：在资源管理器显示
   - <leader>r：重命名
5) CLI Neovim 映射：
   - <leader>f：FFF live grep
   - <leader>o：打开 Oil 文件管理器
   - <leader>k：打开当前/最近文件所在 Git 仓库的 Git changed files 浮动树
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

-- operations
later(function()
  require('mini.ai').setup()
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

  now(function()
    require('mini.cursorword').setup()
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
    add({
      source = 'dmtrKovalenko/fff.nvim',
      hooks = {
        post_install = function(args)
          vim.opt.rtp:prepend(args.path)
          require('fff.download').download_or_build_binary()
        end,
        post_checkout = function(args)
          vim.opt.rtp:prepend(args.path)
          require('fff.download').download_or_build_binary()
        end,
      },
    })

    require('fff').setup({
      lazy_sync = true,
      frecency = {
        enabled = true,
      },
    })

    vim.keymap.set('n', '<leader>e', function()
      require('fff').find_files()
    end, { silent = true, desc = 'FFF find files' })

    vim.keymap.set('n', '<leader>f', function()
      require('fff').live_grep()
    end, { silent = true, desc = 'FFF live grep' })
  end)
  later(function()
    add({ source = 'stevearc/oil.nvim' })
    add({ source = 'nvim-tree/nvim-web-devicons' })
    require('oil').setup({})
    vim.keymap.set('n', '<leader>o', '<cmd>Oil<CR>', { silent = true, desc = 'Open Oil' })
  end)

  later(function()
    add({ source = 'nvim-neo-tree/neo-tree.nvim' })
    add({ source = 'nvim-lua/plenary.nvim' })
    add({ source = 'MunifTanjim/nui.nvim' })
    add({ source = 'nvim-tree/nvim-web-devicons' })

    require('neo-tree').setup({
      popup_border_style = 'rounded',
      window = {
        position = 'float',
      },
      git_status = {
        window = {
          position = 'float',
        },
      },
    })

    local function git_root_for_path(path)
      local target = path
      if target == nil or target == '' then
        target = vim.fn.getcwd()
      end

      if vim.fn.isdirectory(target) == 0 then
        target = vim.fn.fnamemodify(target, ':p:h')
      end

      local output = vim.fn.systemlist({
        'git',
        '-C',
        target,
        'rev-parse',
        '--show-toplevel',
      })

      if vim.v.shell_error ~= 0 or output[1] == nil or output[1] == '' then
        return nil
      end

      return output[1]
    end

    local function git_context_from_current_or_recent()
      local candidates = {}
      local seen = {}

      local function add_candidate(path)
        if path == nil or path == '' then
          return
        end

        local normalized = vim.fn.fnamemodify(path, ':p')
        if seen[normalized] then
          return
        end

        seen[normalized] = true
        table.insert(candidates, normalized)
      end

      add_candidate(vim.api.nvim_buf_get_name(0))

      local buffers = vim.fn.getbufinfo({ buflisted = 1 })
      table.sort(buffers, function(left, right)
        return (left.lastused or 0) > (right.lastused or 0)
      end)

      for _, buffer in ipairs(buffers) do
        add_candidate(buffer.name)
      end

      add_candidate(vim.fn.getcwd())

      for _, path in ipairs(candidates) do
        local root = git_root_for_path(path)
        if root ~= nil then
          return root, path
        end
      end

      return nil, nil
    end

    vim.keymap.set('n', '<leader>k', function()
      local root, anchor = git_context_from_current_or_recent()
      if root == nil then
        vim.notify('不是 git repo', vim.log.levels.WARN)
        return
      end

      local command = {
        'Neotree',
        'git_status',
        'float',
        'dir=' .. vim.fn.fnameescape(root),
      }

      if anchor ~= nil and anchor ~= '' and anchor:sub(1, #root) == root then
        table.insert(command, 'reveal_file=' .. vim.fn.fnameescape(anchor))
      end

      vim.cmd(table.concat(command, ' '))
    end, { silent = true, desc = 'Open Git changed files' })
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
