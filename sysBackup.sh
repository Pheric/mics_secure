#!/usr/bin/env bash

function setupBackups {
    mkdir /bak
    cd /bak

    mkdir etc
    cp -r /etc/cron* etc/
    mkdir -p var/spool/cron
    cp -r /var/spool/cron/* var/spool/cron/

    chattr -R +i {etc,var}
}

function backup {
    chmod 700 /bak
    cd /bak

    fname="bak_`date +%H_%M`"
    mkdir $fname
    cd $fname

    cp -R {/etc,/var,/home,/root} .
    cd ..

    tar -czf $fname.tar.gz $fname
    echo $fname_fisharehot | gpg --batch --yes --passphrase-fd 0 -c --no-symkey-cache $fname
    rm $fname
    chmod 400 $fname.gpg
    chattr +i $fname.gpg
}

function main {
    cd /
    if [ ! -d "/bak" ]; then
        setupBackups
    fi
    backup
}

main