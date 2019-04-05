#!/usr/bin/env bash

activeServices () {

	echo "Services currently running: "
	service --status-all 2>&1 | grep '+'
	# uncomment below command to filter out [ + ]
	# service --status-all 2>&1 | grep -Po '(?<= \[\ \+ \]  ).*'
}

inactiveServices () {

	echo "Services not running: "
	service --status-all 2>&1 | grep '-'
}

errorServices () {

	echo "Services with errors: "
	service --status-all 2>&1 | grep '?'
}