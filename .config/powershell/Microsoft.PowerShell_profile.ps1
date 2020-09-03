Import-Module posh-git

# Returns Ordinal or OrdinalIgnoreCase to aid in string comparisons.
function Get-CustomPathStringComparison {
    if (($PSVersionTable.PSVersion.Major -ge 6) -and $IsLinux) {
        [System.StringComparison]::Ordinal
    }
    else {
        [System.StringComparison]::OrdinalIgnoreCase
    }
}

# My custom Get-PromptPath which does '~\>' when $Home.
function Get-CustomPromptPath {
    $settings = $global:GitPromptSettings
    $abbrevHomeDir = $settings -and $settings.DefaultPromptAbbreviateHomeDirectory

    $pathInfo = $ExecutionContext.SessionState.Path.CurrentLocation
    $currentPath = if ($pathInfo.Drive) { $pathInfo.Path } else { $pathInfo.ProviderPath }

    $stringComparison = Get-CustomPathStringComparison

    if ($abbrevHomeDir -and $currentPath -and !$currentPath.Equals($Home, $stringComparison) -and $currentPath.StartsWith($Home, $stringComparison)) {
        $currentPath = "~" + $currentPath.SubString($Home.Length)
    } elseif ($abbrevHomeDir -and $currentPath -and $currentPath.Equals($Home, $stringComparison) -and $currentPath.StartsWith($Home, $stringComparison)) {
        $currentPath = "~\"
    }

    return $currentPath
}

# Make posh-git use my custom Get-PromptPath defined above.
$GitPromptSettings.DefaultPromptPath ='$(Get-CustomPromptPath)'

# Don't make posh-git set a title for the window.
$GitPromptSettings.WindowTitle = $null

# Set the window title to my preference.
$TextInfo = (Get-Culture).TextInfo
$Host.UI.RawUI.WindowTitle = $TextInfo.ToTitleCase($env:computername.ToLower())

# A where/which replacement.
function Get-CustomCommand($command) {
    #Get-Command $command | Select-Object -ExpandProperty Path
    Get-Command $command | Format-Table Path
}

# And set it to a 'which' alias.
New-Alias which Get-CustomCommand

# Alias for PGO.
New-Alias pgo pgo-wrapper.bat

# Enable the Rubin's Java version manager.
. $home\Syncthing\Source\RAAF\scripts\power\jdkctl.ps1
