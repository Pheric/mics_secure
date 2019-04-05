#!/usr/bin/env bash

# Not sure if these will work as is; will require testing
# MariaDB seems to be built off mysql and should only need minor changes. Not sure if $newpass will expand properly as currently set.

$newpass=Password1! # obviously change this - consider using a secured password config file? encrypt or delete?

function changeMysql {
	mysql.server start
	mysql -u root -e "SET PASSWORD FORroot@'localhost' = PASSWORD('$newpass');"
}

function changeMariadb {
	systemctl start mariadb.service
	mariadb -u root -e "SET PASSWORD FOR root@'localhost' = PASSWORD('$newpass');"
}

function changePostgresql {
	sudo -u postgres psql -U postgres -d postgres -c "alter user postgres with password '$newpass';"
}