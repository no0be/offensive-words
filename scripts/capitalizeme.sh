#!/bin/bash

BASE=/tmp/capitalizeme.$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n1)

# create working file in /tmp
while read line
do
    echo "$line" >> $BASE
done < "${1:-/dev/stdin}"

cat $BASE >> "$BASE.cap"

# capitalize rules
hashcat "$BASE" -j 'l' --stdout >> "$BASE.cap"
hashcat "$BASE" -j 'c' --stdout >> "$BASE.cap"
hashcat "$BASE" -j 'u' --stdout >> "$BASE.cap"

# final sort and clean
sort -u "$BASE.cap"
rm $BASE*
