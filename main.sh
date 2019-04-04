#!/bin/sh

function main {
    echo "MICS Security"
    su - root # so the user is prompted only once

    chmod +x *.sh
    ./sysBackup.sh
    delCron # safe because cron jobs should be saved already. If this fails, we should have a system backup.
    ./firewall.sh
    ./sshdConfigure.sh

    echo "Reminders:"
    echo "1. Disable root login through SSH (line 32)"
    echo "2. Check crontabs (/bak/etc/ and /bak/var/spool/cron/)"
    echo "3. Check sudoers file"
}

function delCron {
    rm -rf /etc/cron*
    rm -rf /var/spool/cron
}


main