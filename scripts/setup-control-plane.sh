#!/usr/bin/env bash

set -e
set -x

control_plane_no="1"

function ssh_exec() {
    ssh -v core@control-plane-${control_plane_no} $@
}

function scp_to_remote() {
    local file="$1"
    local remote_file="$2"
    scp -v core@control-plane-${control_plane_no}:${remote_file} ${file}
}

ssh_exec sudo rpm-ostree install kubelet kubeadm kubectl cri-o
ssh_exec sudo reboot

until ! ping worker-${control_plane_no} -c 1; do
    sleep 10
done
until ping worker-${control_plane_no} -c 1; do
    sleep 10
done
remote_home="/home/core/"
ssh_exec sudo systemctl enable --now crio kubelet
scp_to_remote ./bootstrap/k8s/clusterconfig.yaml ${remote_home}
ssh_exec sudo kubeadm init --config clusterconfig.yaml
ssh_exec mkdir -p ${remote_home}/.kube
ssh_exec sudo cp -i /etc/kubernetes/admin.conf ${remote_home}/.kube/config
ssh_exec sudo chown $(id -u):$(id -g) ${remote_home}/.kube/config
ssh_exec kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml
