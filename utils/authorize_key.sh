# This script adds specified pubkey into authorized_keys file.
# Duplicates are avoided.

PUBKEY="$1"
SSH="$HOME/.ssh"
KEYS="$SSH/authorized_keys"

if [ ! -d $SSH ] ; then
    mkdir -p $SSH
    chmod 0700 $SSH
fi

if [ ! -f $KEYS ] ; then
    touch $KEYS
    chmod 0600 $KEYS
fi

grep -q "$PUBKEY" $KEYS
if [ ! $? -eq 0 ] ; then
    echo "$PUBKEY" >> $KEYS
fi
