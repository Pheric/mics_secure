#!/usr/bin/env bash

function activeServices {

	echo "Services currently running: "
	service --status-all 2>&1 | grep '+'
	# uncomment below command to filter out [ + ]
	# service --status-all 2>&1 | grep -Po '(?<= \[\ \+ \]  ).*'
}

function inactiveServices {

	echo "Services not running: "
	service --status-all 2>&1 | grep '-'
}

function errorServices {

	echo "Services with errors: "
	service --status-all 2>&1 | grep '?'
}