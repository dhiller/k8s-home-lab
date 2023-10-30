#!/usr/bin/env bash
# https://rook.io/docs/rook/v1.12/Getting-Started/quickstart/#tldr

#git clone --single-branch --branch v1.12.6 https://github.com/rook/rook.git
(
    cd ./bootstrap/k8s/rook-ceph || exit
    kubectl create -f crds.yaml -f common.yaml -f operator.yaml
    kubectl create -f cluster.yaml
)
