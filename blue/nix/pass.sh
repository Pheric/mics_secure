#!/bin/sh
	read -p : pass
users=$(getent passwd | grep /bin/.*sh | grep -v root | cut -d ":" -f 1)
for user in $users; do
echo “$user:$pass” | chpasswd
echo “$user:$pass” >> system_name.csv
done
