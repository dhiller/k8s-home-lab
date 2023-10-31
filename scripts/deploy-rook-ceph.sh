#!/usr/bin/env bash
# https://rook.io/docs/rook/v1.12/Getting-Started/quickstart/#tldr

set -e
set -x

#git clone --single-branch --branch v1.12.6 https://github.com/rook/rook.git
(
    cd ./bootstrap/k8s/rook-ceph || exit
    kubectl create -f crds.yaml -f common.yaml -f operator.yaml
    kubectl create -f cluster.yaml
    kubectl create -f rbd-storageclass.yaml cephfs-storageclass.yaml
    kubectl create -f cephfs-storageclass.yaml
)
