# Bootstrap

A minimal bootstrap process for my personal computers.

## Process

Installs
- [Chocolatey](https://chocolatey.org/)
- [Git](https://git-scm.com/)
- [Chef Workstation](https://www.chef.sh/about/chef-workstation/)

Clones
- [kitforbes/chef-repo](https://github.com/kitforbes/chef-repo)

## Usage

Download the bootstrap script (read the contents) and execute the file.

```powershell
$url = 'https://raw.githubusercontent.com/kitforbes/bootstrap/master/bootstrap.ps1'
Invoke-Expression -Command ((New-Object -TypeName System.Net.WebClient).DownloadString($url))
```
