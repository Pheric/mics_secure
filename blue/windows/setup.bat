netsh advfirewall reset 
netsh advfirewall set allprofiles firewallpolicy blockinboundalways,blockoutbound
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f