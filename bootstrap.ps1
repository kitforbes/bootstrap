$env:chocolateyVersion = '0.10.11'
$env:chocolateyUseWindowsCompression = 'true'

$chef = 'C:\opscode\chef-workstation\bin\chef.bat'
$chocolatey = 'C:\ProgramData\chocolatey\bin\choco.exe'
$git = 'C:\Program Files\Git\cmd\git.exe'

if (-not (Test-Path -Path $chocolatey)) {
    Write-Output -InputObject '==> Installing Chocolatey.'
    if (-not (Test-Path -Path 'C:\Windows\Temp\install-chocolatey.ps1')) {
        Invoke-WebRequest -Method Get -Uri 'https://chocolatey.org/install.ps1' -UseBasicParsing -OutFile 'C:\Windows\Temp\install-chocolatey.ps1'
    }

    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
    & 'C:\Windows\Temp\install-chocolatey.ps1'
}

if (-not (Test-Path -Path $git)) {
    Write-Output -InputObject '==> Installing Git.'
    $process = Start-Process -FilePath $chocolatey -ArgumentList 'install', 'git', '--params', '"/GitAndUnixToolsOnPath /NoAutoCrlf /WindowsTerminal /NoShellIntegration /NoCredentialManager /NoGitLfs /SChannel"', '--confirm' -NoNewWindow -Wait -PassThru
    $process.WaitForExit()
    if ($process.ExitCode -ne 0) { exit $process.ExitCode }
}

if (-not (Test-Path -Path $chef)) {
    Write-Output -InputObject '==> Installing Chef Workstation.'
    $process = Start-Process -FilePath $chocolatey -ArgumentList 'install', 'chef-workstation', '--confirm' -NoNewWindow -Wait -PassThru
    $process.WaitForExit()
    if ($process.ExitCode -ne 0) { exit $process.ExitCode }
}

if (-not (Test-Path -Path 'C:\Windows\Temp\chef-repo')) {
    Write-Output -InputObject '==> Cloning chef-repo.'
    $process = Start-Process -FilePath $git -ArgumentList 'clone', '--recurse-submodules', '--jobs', '1', '--depth', '1', '--single-branch', '--no-tags', '"git://github.com/kitforbes/chef-repo.git"', '"C:\Windows\Temp\chef-repo"' -NoNewWindow -Wait -PassThru
    $process.WaitForExit()
    if ($process.ExitCode -ne 0) { exit $process.ExitCode }
}

Push-Location -Path 'C:\Windows\Temp\chef-repo'
# TODO: Run specific role from Chef Repo
$process = Start-Process -FilePath $chef -ArgumentList '-v' -NoNewWindow -Wait -PassThru
$process.WaitForExit()
if ($process.ExitCode -ne 0) { exit $process.ExitCode }

Pop-Location
return $LASTEXITCODE
