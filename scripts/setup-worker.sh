#!/usr/bin/env bash

set -e
set -x

worker_no="$1"
if [ -z ${worker_no} ]; then
    echo "worker number is required!"
    exit 1
fi

function ssh_exec() {
    ssh -v core@worker-${worker_no} $@
}

ssh_exec sudo rpm-ostree install kubelet kubeadm cri-o
ssh_exec sudo reboot

until ! ping worker-${worker_no} -c 1; do
    sleep 10
done
until ping worker-${worker_no} -c 1; do
    sleep 10
done
ssh_exec sudo systemctl enable --now crio kubelet

k8s_join_command=$(ssh core@control-plane-1 "sudo kubeadm token create --print-join-command")
ssh_exec sudo ${k8s_join_command}
