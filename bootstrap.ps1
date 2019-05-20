#requires -runAsAdministrator

$chef = 'C:\opscode\chef-workstation\bin\chef-client.bat'
$chocolatey = 'C:\ProgramData\chocolatey\bin\choco.exe'
$git = 'C:\Program Files\Git\cmd\git.exe'

if (-not (Test-Path -Path $chocolatey)) {
    Write-Verbose -Message 'Installing Chocolatey.'
    if (-not (Test-Path -Path 'C:\Windows\Temp\install-chocolatey.ps1')) {
        Invoke-WebRequest -Method Get -Uri 'https://chocolatey.org/install.ps1' -UseBasicParsing -OutFile 'C:\Windows\Temp\install-chocolatey.ps1'
    }

    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
    $env:chocolateyVersion = '0.10.11'
    $env:chocolateyUseWindowsCompression = 'true'
    & 'C:\Windows\Temp\install-chocolatey.ps1'
}

if (-not (Test-Path -Path $git)) {
    Write-Verbose -Message 'Installing Git.'
    $process = Start-Process -FilePath $chocolatey -ArgumentList 'install', 'git', '--params', '"/GitAndUnixToolsOnPath /NoAutoCrlf /WindowsTerminal /NoShellIntegration /NoCredentialManager /NoGitLfs /SChannel"', '--confirm' -NoNewWindow -Wait -PassThru
    $process.WaitForExit()
    if ($process.ExitCode -ne 0) { exit $process.ExitCode }
}

if (-not (Test-Path -Path $chef)) {
    Write-Verbose -Message 'Installing Chef Workstation.'
    $process = Start-Process -FilePath $chocolatey -ArgumentList 'install', 'chef-workstation', '--confirm' -NoNewWindow -Wait -PassThru
    $process.WaitForExit()
    if ($process.ExitCode -ne 0) { exit $process.ExitCode }
}

if (-not (Test-Path -Path 'C:\Windows\Temp\chef-repo')) {
    Write-Verbose -Message 'Cloning chef-repo.'
    $process = Start-Process -FilePath $git -ArgumentList 'clone', '--recurse-submodules', '--jobs', '1', '--depth', '1', '--single-branch', '--no-tags', '"git://github.com/kitforbes/chef-repo.git"', '"C:\Windows\Temp\chef-repo"' -NoNewWindow -Wait -PassThru
    $process.WaitForExit()
    if ($process.ExitCode -ne 0) { exit $process.ExitCode }
}

$result = & 'C:\Windows\Temp\chef-repo\run-chef-client.ps1'

return $result
