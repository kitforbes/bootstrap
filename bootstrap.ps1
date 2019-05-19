$env:chocolateyVersion = '0.10.11'
$env:chocolateyUseWindowsCompression = 'true'

# Install Chocolatey.
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
Invoke-Expression -Command ((New-Object -TypeName System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Git.
$process = Start-Process -FilePath 'C:\ProgramData\chocolatey\bin\choco.exe' -ArgumentList 'install', 'git', '--params', '"/GitAndUnixToolsOnPath /NoAutoCrlf /WindowsTerminal /NoShellIntegration /NoCredentialManager /NoGitLfs /SChannel"', '--confirm' -NoNewWindow -Wait -PassThru
$process.WaitForExit()
if ($process.ExitCode -ne 0) { exit $process.ExitCode }

# Install Chef Workstation.
$process = Start-Process -FilePath 'C:\ProgramData\chocolatey\bin\choco.exe' -ArgumentList 'install', 'chef-workstation', '--confirm' -NoNewWindow -Wait -PassThru
$process.WaitForExit()
if ($process.ExitCode -ne 0) { exit $process.ExitCode }

# Clone temporary chef-repo repository.
$process = Start-Process -FilePath 'C:\Program Files\Git\cmd\git.exe' -ArgumentList 'clone', '--recurse-submodules', '--jobs', '1', '--depth', '1' '--single-branch' '--no-tags' '"git://github.com/kitforbes/chef-repo.git"' '"C:\Windows\Temp\chef-repo"' -NoNewWindow -Wait -PassThru
$process.WaitForExit()
if ($process.ExitCode -ne 0) { exit $process.ExitCode }

Push-Location -Path 'C:\Windows\Temp\chef-repo'
# TODO: Run specific role from Chef Repo
$process = Start-Process -FilePath 'C:\opscode\chef-workstation\bin\chef.bat' -ArgumentList '-v' -NoNewWindow -Wait -PassThru
$process.WaitForExit()
if ($process.ExitCode -ne 0) { exit $process.ExitCode }

Pop-Location
exit $LASTEXITCODE
