# LazySpray

LazySpray is a PowerShell Script that allow us to spray a set of credential against all domain computers. 

# Usage

* Import into powershell
```
Import-Module .\Invoke-LazySpray.ps1
```

* Supply positional arguments `-Username` and `-Password`
```
Invoke-LazySpray -Username contoso\admin -Password 'G0dth1sisgr3at!' -Verbose
```