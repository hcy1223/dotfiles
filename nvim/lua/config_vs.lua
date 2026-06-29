local M = {}

function M.setup()
  local vscode = require('vscode')

  vim.keymap.set({ 'n', 'x', 'i' }, '<leader>b', function()
    vscode.action('editor.action.revealDefinition')
  end)

  vim.keymap.set({ 'n', 'x', 'i' }, '<leader>o', function()
    vscode.action('revealInExplorer')
  end)

  vim.keymap.set({ 'n', 'x', 'i' }, '<leader>r', function()
    vscode.action('editor.action.rename')
  end)

  -- vim.keymap.set({ 'n', 'x', 'i' }, '<D-l>', function()
  --   vscode.action('editor.action.formatDocument')
  -- end)

  -- vim.keymap.set({ 'n', 'x', 'i' }, '<A-j>', function()
  --   vscode.action('editor.action.quickFix')
  -- end)
end

return M
