DESTINATION="$1"
GATEWAY="$2"

while ip route delete "$DESTINATION" ; do :; done >/dev/null 2>&1
ip route replace "$DESTINATION" via "$GATEWAY"
