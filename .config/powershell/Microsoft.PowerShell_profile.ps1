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

function Find-RegistryValue (
    [string] $seek = $(throw “seek required.”),
    [System.Management.Automation.PathInfo] $regpath = (Get-Location) ) {

    if ($regpath.Provider.Name -ne “Registry”) { throw “regpath required.” }

    $keys = @(Get-Item $regpath -ErrorAction SilentlyContinue) `
        + @(Get-ChildItem -recurse $regpath -ErrorAction SilentlyContinue);

    $results = @();

    foreach ($key in $keys) {
        foreach ($vname in $key.GetValueNames()) {
            $val = $key.GetValue($vname);
            if ($val -match $seek) {
                $r = @{};
                $r.Key = $key;
                $r.ValueName = $vname;
                $r.Value = $val;
                $results += $r;
            }
        }
    }

    $results;
}

function Replace-RegistryValue (
    [string] $seek = $(throw “seek required.”),
    [string] $swap = $(throw “swap required.”),
    [System.Management.Automation.PathInfo] $regpath = (Get-Location) ) {

    $find = Find-RegistryValue -seek $seek -regpath $regpath;
    $results = @();

    foreach ($target in $find) {
        $nval = $target.Value -replace $seek, $swap;
        $r = @{};
        $r.Key = $target.Key;
        $r.ValueName = $target.ValueName;
        $r.OldValue = $target.Value;
        $r.NewValue = $nval;
        $results += $r;
        $wKey = (Get-Item $r.Key.PSParentPath).OpenSubKey($r.Key.PSChildName, “True”);
        $wKey.SetValue($target.ValueName, $nval);
    }

    $results;
}
# Make posh-git use my custom Get-PromptPath defined above.
$GitPromptSettings.DefaultPromptPath = '$(Get-CustomPromptPath)'

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

function Set-VCVars($arch) {
    $tempFile = [IO.Path]::GetTempFileName()

    ## Store the output of cmd.exe.  We also ask cmd.exe to output
    ## the environment table after the batch file completes

    cmd /c " vcvarsall.bat $arch` && set > `"$tempFile`" "

    ## Go through the environment variables in the temp file.
    ## For each of them, set the variable in our local environment.
    Get-Content $tempFile | Foreach-Object {
        if($_ -match "^(.*?)=(.*)$")
        {
            Set-Content "env:\$($matches[1])" $matches[2]
        }
    }

    Remove-Item $tempFile
}

# Set aan alias for vcvarsall.
New-Alias vcvarsall Set-VCVars

# Set a 'which' equivalent alias.
New-Alias which Get-CustomCommand

# Set an alias for PGO.
New-Alias pgo pgo-wrapper.bat

# Enable Java version manager.
. $home\Syncthing\Source\RAAF\scripts\power\jdkctl.ps1
