#!/bin/bash

BASE=/tmp/leetme.$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n1)

# create working file in /tmp
while read line
do
	echo "$line" >> $BASE
done < "${1:-/dev/stdin}"

# lowercase
hashcat "$BASE" -j 'l' --stdout > "$BASE.1"

# leetspeak (up to 5 appearances of the same character)
# $1 = sourcefile
# $2 = match
# $3 = replace
function leetspeak() {
    cat "$1"

    hashcat "$1" -j "%1$2 Dp ip$3" --stdout
    hashcat "$1" -j "%2$2 Dp ip$3" --stdout
    hashcat "$1" -j "%3$2 Dp ip$3" --stdout
    hashcat "$1" -j "%4$2 Dp ip$3" --stdout
    hashcat "$1" -j "%5$2 Dp ip$3" --stdout
    
    hashcat "$1" -j "s$2$3" --stdout
}

leetspeak "$BASE.1" 'i' '1' > "$BASE.2"
leetspeak "$BASE.2" 'i' '!' > "$BASE.1"
leetspeak "$BASE.1" 'o' '0' > "$BASE.2"
leetspeak "$BASE.2" 's' '$' > "$BASE.1"
leetspeak "$BASE.1" 'e' '3' > "$BASE.2"
leetspeak "$BASE.2" 'a' '@' > "$BASE.1"

# final sort and clean
sort -u "$BASE.1"
rm $BASE*
