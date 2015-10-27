#!/bin/bash
set -eufo pipefail

function check-cmds {
    for var in "$@"; do
        if ! hash $var 2>/dev/null; then
            echo "$var not found, quitting"
            exit
        fi
    done
}

# Check if we have all the tools we need
check-cmds actool curl

# Set up directory structure
mkdir -p app/rootfs/{usr/bin,etc/confd,mount}
cp manifest app/

# Download confd
if ! [[ -x "confd" || -x "app/rootfs/usr/bin/confd" ]]; then
    curl -sSLo confd https://github.com/kelseyhightower/confd/releases/download/v0.10.0/confd-0.10.0-linux-amd64
    chmod +x confd
    mv confd app/rootfs/usr/bin/confd
fi

# Pack ACI
actool build app/ confd.aci

# Clean up
rm -rf app
echo "finished"
