# Neovim 插件使用手册

> 配置文件：`/Users/chenyuanhu/.config/nvim/init.lua`

本文档基于当前 `init.lua` 中已启用的插件生成。

## 1. 已启用插件清单

1. `nvim-mini/mini.nvim`
2. `mini.statusline`
3. `mini.basics`
4. `mini.animate`
5. `mini.cursorword`
6. `mini.ai`
7. `ggandor/leap.nvim`
8. `otavioschwanck/arrow.nvim`（仅 CLI Neovim）

## 2. mini.statusline

### 作用
显示状态栏（模式、文件名、位置等）。

### 当前配置
- `require('mini.statusline').setup()`

### 使用
- 自动生效，无需手动命令。

## 3. mini.basics

### 作用
提供一组“开箱即用”的基础编辑行为（缩进、搜索、窗口/映射等默认优化）。

### 当前配置
- `require('mini.basics').setup()`（默认配置）

### 使用
- 自动生效。
- 若想确认最终设置，可在 Neovim 中用 `:set` 查看具体选项值。

## 4. mini.animate

### 作用
给滚动、光标移动、窗口调整等操作增加平滑动画。

### 当前配置
- `require('mini.animate').setup()`（默认配置）

### 使用
- 自动生效。
- 如果觉得动画慢，可后续调小持续时间或按模块关闭。

## 5. mini.cursorword

### 作用
高亮当前光标所在单词，便于快速定位同词。

### 当前配置
- `require('mini.cursorword').setup()`（默认配置）

### 使用
- 自动生效，移动光标即可看到高亮。

## 6. mini.ai

### 作用
增强文本对象，让 `a` / `i` 选择更智能。

### 当前配置
- `require('mini.ai').setup()`（默认配置）

### 常用示例
1. `vi"`：选中引号内内容
2. `va"`：选中含引号的整体
3. `ci(`：修改括号内内容
4. `da)`：删除含括号的整体对象

## 7. leap.nvim

### 作用
在当前窗口快速跳转。

### 当前配置
- `require('leap').setup({})`
- 映射：`f` -> `<Plug>(leap)`（n/x/o 模式）
- 高亮：`LeapBackdrop` 链接到 `Comment`

### 使用步骤
1. 按 `f`
2. 输入目标字符
3. 选择标签完成跳转

### 注意
- 当前配置会覆盖 Vim 原生 `f`（行内查找）行为。

## 8. arrow.nvim（仅 CLI Neovim）

### 作用
轻量书签与文件快速跳转。

### 生效条件
- 仅在 `vim.g.vscode == false` 时加载。

### 当前配置
- `show_icons = true`
- `leader_key = ';'`
- `buffer_leader_key = 'm'`

### 使用
- 具体默认映射依插件版本可能不同。
- 建议在 Neovim 内查看：
1. `:map ;`
2. `:map m`
3. `:checkhealth arrow`

## 9. VSCode Neovim 专用映射

当 `vim.g.vscode == true` 时启用：

1. `<leader>b`：`editor.action.revealDefinition`
2. `<leader>o`：`revealInExplorer`
3. `<leader>r`：`editor.action.rename`

说明：当前文件里未显式设置 `mapleader`，实际 leader 以你的全局/默认配置为准。
