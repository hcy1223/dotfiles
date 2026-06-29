#Requires -Version 5.1

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$timestamp = Get-Date -Format "yyyyMMddHHmmss"

if (-not $env:LOCALAPPDATA) {
    throw "LOCALAPPDATA is not set. Cannot locate the Neovim config directory."
}

if (-not $env:APPDATA) {
    throw "APPDATA is not set. Cannot locate the VS Code User directory."
}

$nvimConfig = Join-Path $env:LOCALAPPDATA "nvim"
$vscodeUser = Join-Path $env:APPDATA "Code\User"

function Backup-Path {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path
    )

    $item = Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
    if (-not $item) {
        return
    }

    if ($item.LinkType) {
        Remove-Item -LiteralPath $Path -Force
        return
    }

    Move-Item -LiteralPath $Path -Destination "$Path.backup.$timestamp"
}

function New-DotfileLink {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Target,

        [Parameter(Mandatory = $true)]
        [string] $Link
    )

    New-Item -ItemType SymbolicLink -Path $Link -Target $Target | Out-Null
}

New-Item -ItemType Directory -Path (Split-Path -Parent $nvimConfig) -Force | Out-Null
Backup-Path $nvimConfig
New-DotfileLink -Target (Join-Path $repoRoot "nvim") -Link $nvimConfig

New-Item -ItemType Directory -Path $vscodeUser -Force | Out-Null
Backup-Path (Join-Path $vscodeUser "settings.json")
Backup-Path (Join-Path $vscodeUser "keybindings.json")
Backup-Path (Join-Path $vscodeUser "snippets")
New-DotfileLink -Target (Join-Path $repoRoot "vscode\User\settings.json") -Link (Join-Path $vscodeUser "settings.json")
New-DotfileLink -Target (Join-Path $repoRoot "vscode\User\keybindings.json") -Link (Join-Path $vscodeUser "keybindings.json")
New-DotfileLink -Target (Join-Path $repoRoot "vscode\User\snippets") -Link (Join-Path $vscodeUser "snippets")
