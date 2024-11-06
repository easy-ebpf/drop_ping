#!/bin/bash
set -x
set -e

if [ $# -lt 1 ]; then
    echo "missing argument"
    echo "usage: ./load.sh <ifname>"
    exit 1
fi

sudo mount -t bpf bpf /sys/fs/bpf/

# check if old program already loaded
if [ -e "/sys/fs/bpf/drop_ping" ]; then
    echo ">>> drop_ping already loaded, uninstalling..."
    ./unload.sh
    echo ">>> old program already deleted..."
fi

sudo bpftool prog load drop_ping.bpf.o /sys/fs/bpf/drop_ping
sudo bpftool net attach xdp pinned /sys/fs/bpf/drop_ping dev "$1"