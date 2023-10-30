#!/usr/bin/env bash

set -ex

function exec_butane() {
    local input_file="$1"
    local output_file="$2"
    echo "will write output to ${output_file}"
    butane \
        --files-dir ${work_dir} \
        ${input_file} > ${output_file}
#    echo "output:"
#    jq '.' ${output_file} | bat
}

work_dir="$(pwd)/bootstrap/fcos"

(
    cd ${work_dir} || exit
    exec_butane fcos-base.butane.yaml fcos-base.ign
    for file in $(find ${work_dir} -type f -name "fcos-control-plane-*.butane.yaml" -print); do
        exec_butane ${file} ${file/.butane.yaml/.ign}
    done
    for file in $(find ${work_dir} -type f -name "fcos-worker-*.butane.yaml" -print); do
        exec_butane ${file} ${file/.butane.yaml/.ign}
    done
)
