# PowerShell profile
# Add a shortcut: define the function/alias below, then add a line to $MyShortcuts.

$GitRoot = 'C:\git'

# Registry of custom shortcuts, printed on startup by Show-Shortcuts.
$MyShortcuts = [ordered]@{
    'gg'        = "Go to $GitRoot"
    'gg <name>' = "Go to $GitRoot\<name> (Tab completes folder names)"
    'shortcuts' = 'Show this list again'
    'aliases'   = 'Show every built in PowerShell alias'
}

function gg {
    param([string]$Name)
    if ($Name) { Set-Location (Join-Path $GitRoot $Name) }
    else       { Set-Location $GitRoot }
}

Register-ArgumentCompleter -CommandName gg -ParameterName Name -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete)
    Get-ChildItem $GitRoot -Directory -Filter "$wordToComplete*" |
        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_.Name) }
}

function Show-Shortcuts {
    Write-Host ''
    Write-Host 'Custom shortcuts' -ForegroundColor Cyan
    foreach ($key in $MyShortcuts.Keys) {
        Write-Host ('  {0,-12}' -f $key) -ForegroundColor Yellow -NoNewline
        Write-Host $MyShortcuts[$key]
    }
    Write-Host ''
}
Set-Alias shortcuts Show-Shortcuts

function aliases {
    Get-Alias | Sort-Object Name | Format-Wide -Property Name -Column 8
}

Show-Shortcuts
