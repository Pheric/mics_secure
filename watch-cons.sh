#!/usr/bin/env bash

netstat -nta | egrep "State|*" | sed "/\b\(127.0.0.1\)\b/d";
python3 -c 'print("-"*100+"\n")';
ss -nta "( dport = :* )" | sed "/\b\(127.0.0.1\)\b/d";
python3 -c 'print("-"*100+"\n")'
