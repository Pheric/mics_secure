#!/bin/sh

# shellcheck disable=SC2162
read -p "Enter password salt:" salt
users=$(getent passwd | grep '/bin/.*sh' | grep -v root | cut -d ":" -f 1)
for user in $users; do
  password=$(echo "$user" | sha256sum | cut -c-7)$salt
  echo "$user:$password" | chpasswd
done

echo "User passwords are now set to the first 7 chars of the username's sha256sum concatenated with the inputted salt"
echo "Example: \"root:Password1!\" becomes \"root:53175bc$salt\""