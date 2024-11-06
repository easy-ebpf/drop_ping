#!/bin/bash
set -x

if [ $# -lt 1 ]; then
    echo "missing argument"
    echo "usage: ./unload.sh <ifname>"
    exit 1
fi

# detach and clear the bpf programs
sudo bpftool net detach xdp dev "$1"
sudo unlink /sys/fs/bpf/drop_ping