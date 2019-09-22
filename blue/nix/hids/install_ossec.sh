#!/bin/bash

# Installs OSSEC on the current machine, in the current directory.
# Set following variables before running:
repo_host="http://192.168.1.143/"
hids_whitelisted_networks="10.20.1.0/24 10.20.2.1/24"

apt install make curl tar gcc libpcre3-dev

curl "$repo_host/blue/nix/hids/ossec-hids-3.3.0.tar.gz" -o ossec-hids-3.3.0.tar.gz
tar -xzf ossec-hids-3.3.0.tar.gz
echo "$hids_whitelisted_networks" >> ossec-hids-3.3.0/etc/preloaded-vars.conf
./ossec-hids-3.3.0/install.sh
# installed to /root/ossec
/root/ossec/bin/ossec-control start