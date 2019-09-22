#!/bin/sh

main () {
    echo "MICS Security"
    if [ "$EUID" -ne 0 ]
      then echo "This script must be run as root!"
      exit
    fi

    # Commenting out the chmod; scripts should be run only as root. If need, use 70."
    # chmod +x *.sh
    bash pass.sh
    bash userChecker.sh
    bash sysBackup.sh
    delCron # safe because cron jobs should be saved already. If this fails, we should have a system backup.
    bash firewall.sh -C # Saves default fw, safe, and runs rclocalcompat
    bash sshdConfigure.sh
    bash databasepassch.sh
    checkPamHack

    echo "Done:"
    echo "Passwords changed for all users INCLUDING ROOT"
    echo "All user homes removed, shells blocked, and root SSH keys deleted"
    echo "System backed up and encrypted in /bak"
    echo "Crontabs deleted"
    echo "rc.local configured as a service"
    echo "Firewall defaults set"
    echo "SSHD configured"
    echo "MariaDB root password changed: thankschris"
    echo ""
    echo "Reminders:"
    echo "1. Check crontabs (/bak/etc/ and /bak/var/spool/cron/)"
    echo "2. Check sudoers file"

    rm -r ./*.sh
}

delCron () {
    rm -rf /etc/cron*
    rm -rf /var/spool/cron
}

checkPamHack () {
    # making a simple change to the pam.d/su file can allow non-privileged users to escalate without a password.
    # here we check for that and warn the admin if it might be an issue.

    # hash made on my (Eric's) arch machine
    safe="fa85e5cce5d723275b14365ba71a8aad  /etc/pam.d/su"
    check="$(md5sum /etc/pam.d/su)"
    if [ "$safe" != "$check" ]; then
        echo "WARNING: The hash of /etc/pam.d/su does not match the predefined value!"
    fi

    if grep -i -q "permit\.so" /etc/pam.d/su; then
        echo "WARNING: SU HACK WAS FOUND IN /etc/pam.d/su"
    fi
}

main
