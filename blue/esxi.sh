pass=’ComplexPassword2@’
	users=$(cat /etc/passwd | grep /bin/ | grep -v root | cut -d ‘:’ -f 1)
	for user in $users; do
		echo -e “$pass\n$pass’ | passwd -s $user
	done
