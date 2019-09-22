#!/usr/bin/env bash

setupBackups () {
    mkdir /bak
    cd /bak || { echo "Directory /bak not found" ; exit 1; }

    mkdir etc
    if /etc/cron* ; then
    	cp -r /etc/cron* etc/
    	mkdir -p var/spool/cron
    	cp -r /var/spool/cron/* var/spool/cron/
    else 
	echo "No cron installation found."
    fi
    chattr -R +i {etc,var}
}

backup () {
    chmod 700 /bak
    cd /bak || { echo "Directory /bak not found" ; exit 1; }

    # fname="bak_`date +%H_%M`"
    fname="bak_$(date +%H_%M)"
    mkdir "$fname"
    cd "$fname" || { echo "Backup dir not found (line 25)" ; exit 1;  }

    # cp -R {/etc,/var,/home,/root} .
    cp -R {/etc,/var,/root} .
    cd ..

    tar -czf "$fname".tar.gz "$fname"
    echo "$fname_fisharehot" | gpg --batch --yes --passphrase-fd 0 -c --no-symkey-cache "$fname".tar.gz
    rm "$fname"
    chmod 400 "$fname".gpg
    chattr +i "$fname".gpg
    echo "Backup created at $fname with password $fname_fisharehot"
}

main () {
    cd / || { echo "/ doesn't exist? Things are looking pretty bad." ; exit 1;  }
    if [ ! -d "/bak" ]; then
        setupBackups
    fi
    backup
}

main
