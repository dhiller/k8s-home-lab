#/usr/bin/env bash
set -ex

rm -f fcos-*.iso

coreos-installer iso customize \
    --dest-device /dev/sda \
    --dest-ignition bootstrap/fcos/fcos-control-plane.ign \
    -o fcos-control-plane.iso \
    /home/dhiller/Downloads/fedora-coreos-38.20231002.3.1-live.x86_64.iso

coreos-installer iso customize \
    --dest-device /dev/sda \
    --dest-ignition bootstrap/fcos/fcos-worker.ign \
    -o fcos-worker.iso \
    /home/dhiller/Downloads/fedora-coreos-38.20231002.3.1-live.x86_64.iso
