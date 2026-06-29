local M = {}

function M.setup()
  local vscode = require('vscode')

  vim.keymap.set({ 'n', 'x', 'i' }, '<leader>b', function()
    vscode.action('editor.action.revealDefinition')
  end, { desc = 'VSCode reveal definition' })

  vim.keymap.set({ 'n', 'x', 'i' }, '<leader>e', function()
    vscode.action('workbench.action.quickOpen')
  end, { desc = 'VSCode quick open' })

  vim.keymap.set({ 'n', 'x', 'i' }, '<leader>o', function()
    vscode.action('revealInExplorer')
  end, { desc = 'VSCode reveal in explorer' })

  vim.keymap.set({ 'n', 'x', 'i' }, '<leader>r', function()
    vscode.action('editor.action.rename')
  end, { desc = 'VSCode rename' })

  -- vim.keymap.set({ 'n', 'x', 'i' }, '<D-l>', function()
  --   vscode.action('editor.action.formatDocument')
  -- end)

  -- vim.keymap.set({ 'n', 'x', 'i' }, '<A-j>', function()
  --   vscode.action('editor.action.quickFix')
  -- end)
end

return M
