#!/usr/bin/env bash

chattr -i /etc/ssh/sshd_config
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
cp -f "$(dirname "$(readlink -f "$0")")/configs/sshd_config" /etc/ssh/sshd_config
chattr +i /etc/ssh/sshd_config{,.bak}
systemctl restart {sshd,ssh}