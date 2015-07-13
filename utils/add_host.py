#! /usr/bin/env python

import sys

ip = sys.argv[1]
host = sys.argv[2]

with open('/etc/hosts') as fd:
    for entry in fd:
        entry = entry.strip()

        # omit empty lines
        if not entry:
            continue

        entry = [x.strip() for x in entry.split(' ', 1)]
        entry[1] = [x.strip() for x in entry[1].split(' ')]

        if entry[0] == ip and host in entry[1]:
            sys.exit(0)

with open('/etc/hosts', 'a') as fd:
    fd.write("{} {}\n".format(ip, host))
