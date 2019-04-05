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

enableLoopback () {
# Enables the loopback adapter?
	iptables -A INPUT -i lo -j ACCEPT
	iptables -A OUTPUT -o lo -j ACCEPT
}

makeStateful () {
# Accepts all traffic related to already established traffic.
	iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
	iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
}

allowSshd () {
    # drop SSH attempts that exceed 5 every 1m
    iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set
    iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 5 -j DROP
    # no output rule necessary, makeStateful will handle it (unless we need to SSH out)
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
	iptables-save > /root/fw{4,6}.rules
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
	makeStateful
	# end rule functions

	saveConfiguredTable

	if [ ! -f /root/fw4.configured ]; then
	    rclocalRestoreSetup
	    saveConfigured
	fi
}

main
