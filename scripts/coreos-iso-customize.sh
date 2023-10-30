#!/usr/bin/env bash
set -ex

rm -f fcos-*.iso

work_dir="$(pwd)/bootstrap/fcos"
iso_base="/home/dhiller/Downloads/fedora-coreos-38.20231002.3.1-live.x86_64.iso"

(
    for file in $(find ${work_dir} -type f -name "fcos-control-plane-*.ign" -print); do
        rm -f ${file/.ign/.iso}
        coreos-installer iso customize \
            --dest-device /dev/sda \
            --dest-ignition ${file} \
            -o ${file/.ign/.iso} \
            ${iso_base}
    done
    for file in $(find ${work_dir} -type f -name "fcos-worker-*.ign" -print); do
        rm -f ${file/.ign/.iso}
        coreos-installer iso customize \
            --dest-device /dev/sda \
            --dest-ignition ${file} \
            -o ${file/.ign/.iso} \
            ${iso_base}
    done
)
