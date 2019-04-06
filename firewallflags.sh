#!/usr/bin/env bash
# base script using generic iptables checklist

saveUnconfigured () {
	iptables-save > /root/fw{4,6}.unconfigured
}
saveConfigured () {
	iptables-save > /root/fw{4,6}.configured
}

flushTables () {
	iptables -F # clear out old rules
	iptables -X # clears out all chains
}

dropTables () {
# Default drop all connections
	iptables -P INPUT DROP
	iptables -P OUTPUT DROP
	iptables -P FORWARD DROP
}

makeStateful () {
	iptables -P OUTPUT ACCEPT
}

makeStateless () {
	iptables -P OUTPUT DROP
}
	

enableLoopback () {
# Enables the loopback adapter?
	iptables -A INPUT -i lo -j ACCEPT
	iptables -A OUTPUT -o lo -j ACCEPT
}

makeRelations () {
# Accepts all traffic related to already established traffic.
	iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
	iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
}

allowSshd () {
    # drop SSH attempts that exceed 5 every 1m
    iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set
    iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 5 -j DROP
    # no output rule necessary, makeRelations will handle it (unless we need to SSH out)
}

# Additional considerations:
passiveFTP () {
	iptables -A INPUT -p tcp -m multiport --dports 65500:65502 -j ACCEPT # passive FTP
}

activeFTP () {
	iptables -A OUTPUT -p tcp --sport 20 -j ACCEPT # non-passive FTP
}

allowMySql () {
	# Universal access
	iptables -A INPUT -i eth0 -p tcp -m tcp --dport 3306 -j ACCEPT
	# Additional info:
	# https://www.cyberciti.biz/tips/linux-iptables-18-allow-mysql-server-incoming-request.html
	
	# Consider allowing ONLY the IP addresses that matter, not all IP addresses, example:
	# iptables -A INPUT -p tcp -s 202.54.1.50 --sport 1024:65535 -d 202.54.1.20 --dport 3306 -m state --state NEW,ESTABLISHED -j ACCEPT
	# iptables -A OUTPUT -p tcp -s 202.54.1.20 --sport 3306 -d 202.54.1.50 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT
}
# Scored service required:
#iptables -A INPUT -p <tcp/udp> --dport <destinationPort> -j ACCEPT 

# Service needed by other systems:
#iptables -A INPUT -p <tcp/udp> -s <sourceIP> --dport <destinationPort> -j ACCEPT

# Service this system needs from another:
#iptables -A OUTPUT -p <tcp/udp> -d <destinationIP> --dport <destinationport> -j ACCEPT


saveConfiguredTable () {
	chattr -i /root/fw4.rules
	chattr -i /root/fw6.rules
	# iptables-save > /root/fw{4,6}.rules

	iptables-save > /root/fw4.rules
	iptables-save > /root/fw6.rules
	
	chattr -i /root/fw4.rules
	chattr -i /root/fw6.rules
}

restoreConfiguredTable () {
	# iptables-restore < /root/fw{4,6}.rules
	iptables-restore > /root/fw4.rules
	iptables-restore > /root/fw6.rules
}

rclocalRestoreSetup () {
	if [ ./rclocalCompat.sh -ne 0 ]; then
    	echo "rc.local configuration failed! Nonzero status code for rclocalCompat.sh" > /dev/stderr
	else
    	chattr -i /etc/rc.local
    	echo "iptables-restore /root/fw{4,6}.rules" >> /etc/rc.local
    	chattr +i /etc/rc.local
	fi
}

main () {
    if [ ! -f /root/fw4.configured ]; then
	    saveUnconfigured
    fi

	flushTables
	dropTables

	# rule functions
	enableLoopback
	allowSshd
	makeRelations
	# end rule functions

	saveConfiguredTable

	if [ ! -f /root/fw4.configured ]; then
	    rclocalRestoreSetup
	    saveConfigured
	fi
}

while [ "$1" != "" ]; do
	# Follow this format to add new flags
	case $1 in
		# This will check for the -f or --flushTables argument in the command line call
		-F | --flushTables )
			# Code runs here
			# this if statement is more for example purposes to showcase shift
			if [ "$2" = "echo" ] || [ "$2" = "print" ]; then
				echo "Flushing Tables"
				flushTables
				shift
			else
				flushTables
			fi
			shift
			;;
		-Sf | --statefull )
			makeStateful
			shift		
			;;
		-Sl | --stateless )
			makeStateless
			shift			
			;;
		-Ss | --ssh )
			allowSshd
			shift			
			;;
		-M | --mysql )
			allowMySql			
			shift					
			;;
		-R | --restore )
			restoreConfiguredTable
			shift
			;;
		-C | --config )
			main
			shift
			;;	
		-h | --help | "" )
			echo "-h | --help: Shows this menu."
		# this will shift through all "bad" input (ignore it) in order to process valid flags.
		* ) shift
			;;
	esac
	shift
done
