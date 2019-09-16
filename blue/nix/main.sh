#!/bin/sh

main () {
    echo "MICS Security"
    if [ "$EUID" -ne 0 ]
      then echo "This script must be run as root!"
      exit
    fi

    # Commenting out the chmod; scripts should be run only as root. If need, use 70."
    # chmod +x *.sh
    bash sysBackup.sh
    delCron # safe because cron jobs should be saved already. If this fails, we should have a system backup.
    bash firewall.sh -C
    bash sshdConfigure.sh
    checkPamHack

    echo "Reminders:"
    echo "1. Disable root login through SSH (line 32)"
    echo "2. Check crontabs (/bak/etc/ and /bak/var/spool/cron/)"
    echo "3. Check sudoers file and rc.local"
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
