$Users = Get-WmiObject -Class Win32_UserProfile
$IgnoreList = "NetworkService", "Administrator"

:OuterLoop
foreach ($User in $Users) {
    foreach ($name in $IgnoreList) {
        if ($User.localpath -like "*\$name") {
            continue OuterLoop
        }
    }

    $User.Delete()
}

Read-Host -Prompt "Press Enter to continue"