del %TEMP% /q/s
del C:\Windows\Temp /q/s
rmdir %TEMP% /q/s
rmdir C:\Windows\Temp /q/s
Remove-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" -Recurse
Remove-Item "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" -Recurse
Remove-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Recurse
Remove-Item "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Recurse

