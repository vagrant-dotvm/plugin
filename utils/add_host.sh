# This script adds new host entry and avoid duplicates.

quote() {
    sed 's/[]\.|$(){}?+*^]/\\&/g' <<< "$*"
}

ip="$1"
host="$2"

# Check whether specific IP has specific HOST, if not add entry.
egrep "^$(quote "$ip")\s+" /etc/hosts | cut -d' ' -f2- | egrep -q "(\s+|^)$(quote "$host")(\s+|$)"
[ $? -eq 0 ] || echo "$ip $host" >> /etc/hosts
