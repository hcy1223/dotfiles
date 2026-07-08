# Neovim 插件使用手册

> 配置文件：`/Users/chenyuanhu/.config/nvim/init.lua`

本文档基于当前 `init.lua` 中已启用的插件生成。

## 维护规则

如果 `nvim/` 下的 Neovim 配置发生变化，尤其是插件启用条件、插件配置、快捷键映射或 VSCode Neovim 分支逻辑发生变化，必须同步更新本文档，确保手册与实际配置保持一致。

## 1. 启用策略

配置会按运行环境分层加载：

| 插件 / 功能 | CLI Neovim | VSCode Neovim | 说明 |
| --- | --- | --- | --- |
| `mini.basics` | 是 | 是 | 基础编辑行为；设置 `<leader>` 为空格 |
| `mini.ai` | 是 | 是 | Vim 文本对象增强，VS Code 本身不提供 |
| `leap.nvim` | 是 | 是 | 快速跳转，补足 Vim 编辑体验 |
| `mini.statusline` | 是 | 否 | VS Code 已有状态栏 |
| `mini.animate` | 是 | 否 | VS Code 已处理编辑器动画/滚动体验 |
| `mini.cursorword` | 是 | 否 | VS Code 已有同词/引用高亮能力 |
| `mini.indentscope` | 是 | 否 | VS Code 已有缩进参考线 |
| `fff.nvim` | 是 | 否 | CLI frecency 文件搜索和 live grep；VS Code 有 Quick Open / Search |
| `spinner.nvim` | 是 | 否 | CLI UI 辅助，VS Code 不需要 |
| `arrow.nvim` | 是 | 否 | CLI 文件书签；VS Code 有工作区/打开文件体验 |
| `oil.nvim` | 是 | 否 | CLI 文件管理；VS Code 有 Explorer |
| `neo-tree.nvim` | 是 | 否 | CLI Git changed files 浮动树；VS Code 有 Source Control |
| `noice.nvim` | 是 | 否 | CLI 命令行/消息 UI；VS Code 不需要 |
| `theme` / `koda.nvim` | 是 | 否 | VS Code 主题由 VS Code 管理 |

VSCode Neovim 分支只保留“编辑语义”相关能力，不加载 VS Code 已经负责的 UI、文件管理、工作区和视觉类插件。

## 2. mini.statusline

### 作用
显示状态栏（模式、文件名、位置等）。

### 当前配置
- `require('mini.statusline').setup()`
- 仅 CLI Neovim 加载。

### 使用
- 自动生效，无需手动命令。

## 3. mini.basics

### 作用
提供一组“开箱即用”的基础编辑行为（缩进、搜索、窗口/映射等默认优化）。

### 当前配置
- `require('mini.basics').setup()`（默认配置）
- CLI Neovim 和 VSCode Neovim 都加载。

### 使用
- 自动生效。
- 若想确认最终设置，可在 Neovim 中用 `:set` 查看具体选项值。

## 4. mini.animate

### 作用
给滚动、光标移动、窗口调整等操作增加平滑动画。

### 当前配置
- `require('mini.animate').setup()`（默认配置）
- 仅 CLI Neovim 加载。

### 使用
- 自动生效。
- 如果觉得动画慢，可后续调小持续时间或按模块关闭。

## 5. mini.cursorword

### 作用
高亮当前光标所在单词，便于快速定位同词。

### 当前配置
- `require('mini.cursorword').setup()`（默认配置）
- 仅 CLI Neovim 加载。

### 使用
- 自动生效，移动光标即可看到高亮。

## 6. mini.ai

### 作用
增强文本对象，让 `a` / `i` 选择更智能。

### 当前配置
- `require('mini.ai').setup()`（默认配置）
- CLI Neovim 和 VSCode Neovim 都加载。

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
- CLI Neovim 和 VSCode Neovim 都加载。

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
2. `<leader>e`：`workbench.action.quickOpen`
3. `<leader>o`：`revealInExplorer`
4. `<leader>r`：`editor.action.rename`

说明：`mini.basics` 会在未设置时把 `<leader>` 设置为空格。

## 10. fff.nvim（仅 CLI Neovim）

### 作用
提供 frecency 排序的文件名模糊搜索和项目内 live grep。

打开文件搜索时，默认展示最近/常访问文件；输入关键字后按模糊匹配结果过滤，并继续结合 frecency 权重排序。

### 当前配置
- 插件：`dmtrKovalenko/fff.nvim`
- 安装 hook：调用 `require('fff.download').download_or_build_binary()` 下载预编译二进制；若不可用则按插件逻辑回退构建。
- `lazy_sync = true`
- `frecency.enabled = true`
- 映射：`<leader>e` -> `require('fff').find_files()`
- 映射：`<leader>f` -> `require('fff').live_grep()`

### 使用
1. `<leader>e`：按 frecency 模糊搜索文件名/路径。
2. `<leader>f`：项目内搜索文件内容。

### 注意
- `fff.nvim` 需要额外的本地二进制组件；首次安装或更新时会下载预编译二进制，必要时回退到本机构建。
- 若搜索索引异常，可在 Neovim 内执行 `:FFFHealth` 检查，或执行 `:FFFScan` 重新扫描。

### 为什么 VSCode Neovim 不加载
VS Code 已有 Quick Open、最近文件和全局搜索。VSCode Neovim 分支中 `<leader>e` 直接调用 `workbench.action.quickOpen`，避免重复维护另一套文件搜索 UI。

## 11. neo-tree.nvim（仅 CLI Neovim）

### 作用
以浮动窗口打开 Git changed files 树，快速查看当前仓库中有变更的文件。

### 当前配置
- 插件：`nvim-neo-tree/neo-tree.nvim`
- 依赖：`nvim-lua/plenary.nvim`、`MunifTanjim/nui.nvim`、`nvim-tree/nvim-web-devicons`
- `popup_border_style = 'rounded'`
- `window.position = 'float'`
- `git_status.window.position = 'float'`
- 映射：`<leader>k` -> 打开 Git changed files 浮动树

### 定位规则
按 `<leader>k` 时，会按以下顺序寻找 Git 仓库：

1. 当前 buffer 对应的文件
2. 最近使用过的已列出 buffer
3. 当前工作目录

找到仓库后，打开 `neo-tree` 的 `git_status` source，并尽量 reveal 当前或最近文件。若以上位置都不属于 Git 仓库，会提示：`不是 git repo`。

### 为什么 VSCode Neovim 不加载
VS Code 已有 Source Control 视图和文件树，VSCode Neovim 分支不重复加载 Git changed files UI。
