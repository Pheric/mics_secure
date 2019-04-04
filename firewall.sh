#!/usr/bin/env bash
# base script using generic iptables checklist

function saveUnconfigured {
	iptables-save > /root/fw4.unconfigured
}

function flushTables {
	iptables -F # clear out old rules
	iptables -X # clears out all chains
}

function dropTables {
# Default drop all connections
	iptables -p INPUT DROP
	iptables -p OUTPUT DROP
	iptables -P FORWARD DROP
}

function enableLoopback {
# Enables the loopback adapter?
	iptables -A INPUT -i lo -j ACCEPT
	iptables -A OUTPUT -o lo -j ACCEPT
}

function makeStateful {
# Accepts all traffic related to already established traffic.
	iptables -A INPUT -m state --state RELATED, ESTABLISHED -j ACCEPT
	iptables -A OUTPUT -m state --state RELATED, ESTABLISHED -j ACCEPT
}

# Additional considerations:
function passiveFTP {
	iptables -A INPUT -p tcp -m multiport --dports 65500:65502 -j ACCEPT # passive FTP
}
function activeFTP {
	iptables -A OUTPUT -p tcp --sport 20 -j ACCEPT # non-passive FTP
}

# Scored service required:
#iptables -A INPUT -p <tcp/udp> --dport <destinationPort> -j ACCEPT 

# Service needed by other systems:
#iptables -A INPUT -p <tcp/udp> -s <sourceIP> --dport <destinationPort> -j ACCEPT

# Service this system needs from another:
#iptables -A OUTPUT -p <tcp/udp> -d <destinationIP> --dport <destinationport> -j ACCEPT


function saveConfiguredTable {
	iptables-save > /root/fw{4,6}.{rules,configured}
}


# TODO: configure systemd service if rc.local doesn't exist
function restoreTable {
	chattr -i /etc/rc.local
	echo "iptables-restore /root/fw{4,6}.rules" >> /etc/rc.local
	chmod +x /etc/rc.local
	chattr +i /etc/rc.local
}

function main {
	saveUnconfigured
	flushTables
	dropTables
	enableLoopback
	makeStateful
	saveConfiguredTable
	restoreTable
}

main