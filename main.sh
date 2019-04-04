#!/bin/sh

function main {
  echo "MICS Security"
  su - root # so the user is prompted only once

  chmod +x {sysBackup.sh,firewall.sh,rclocalCompat.sh}
 ./sysBackup.sh
 ./firewall.sh
}

main