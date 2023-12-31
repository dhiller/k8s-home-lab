# k8s-home-lab

k8s home lab bootstrap and configuration repository

## Bootstrapping cluster nodes

Bootstrapping of cluster nodes is done in two steps:
1. installing FCOS on a node
2. setting up the node

As preparation a fcos image is required, which will be configured for automatic installation of each node with a specific iso file.

Customizing the isos is done by executing

```bash
./scripts/coreos-iso-customize.sh
```

in a terminal. This will generate a set of iso files inside the `bootstrap/fcos` folder. Each iso can then be written to a usb drive using i.e. Fedora Media Writer.

> [!NOTE]
> When installing a node currently we need to use an attached keyboard to enter the boot menu

After node installation has been finished, we can setup worker nodes by executing 

```bash
./scripts/setup-worker.sh 1
```

> [!NOTE]
> control-plane configuration setup script is not yet there

## Applying bootstrap configuration changes

FCOS uses [Ignition](https://coreos.github.io/ignition/) for installation configuration, the `.ign` files are re-generated by executing

```bash
./scripts/generate-ignition.sh
```

[Butane](https://coreos.github.io/butane/upgrading-fcos/) configuration files are used as configuration source. The base configuration file `fcos-base.butane.yaml` contains the common configuration for all nodes. `fcos-control-plane-{x}.butane.yaml` contains configuration for each control-plane node, `fcos-worker-{x}.butane.yaml` contains configuration for each worker node.

Worker nodes currently have an added partition that will be configured for use by ceph cluster (see below). 

## Deploying rook-ceph

Execute

```bash
./scripts/deploy-rook-ceph.sh
```

> [!WARNING]
> [rook-ceph cluster configuration](./bootstrap/k8s/rook-ceph/cluster.yaml) is not intended for production use!

## Deploying [KubeVirt](kubevirt.io) and [CDI](https://github.com/kubevirt/containerized-data-importer)

> [!IMPORTANT]
> [dhiller/kubevirt-testing repo](github.com/dhiller/kubevirt-testing) is required for the script to work

Execute

```bash
./scripts/deploy-kubevirt.sh
```

to install both components.

> [!NOTE]
> CDI requires the testing component nodeport upload proxy currently to upload images

To install node port upload proxy service, execute

```bash
kubectl create -f ./bootstrap/k8s/cdi/uploadproxy-nodeport.yaml
```

Then use a port-forward to expose the upload nodeport service

```bash
kubectl port-forward -n cdi service/cdi-uploadproxy-nodeport 18443:443 &
```

Example upload:
```bash
kubectl virt image-upload pvc win10cd-pvc --size 6Gi \
    --image-path=$HOME/Downloads/Win10_22H2_German_x64v1.iso \
    --storage-class rook-ceph-block --block-volume --insecure \
    --uploadproxy-url=https://127.0.0.1:18443
```

## References
* [Creating a Kubernetes cluster with fedora coreos (Carmine Zaccagnino)](https://dev.to/carminezacc/creating-a-kubernetes-cluster-with-fedora-coreos-36-j17)
* [Setting up single node ceph cluster for Kubernetes (V. Rusinov)](https://www.rusinov.ie/en/posts/2020/setting-up-single-node-ceph-cluster-for-kubernetes/)
* [The Ultimate Rook And Ceph Survival Guide (CloudOps)](https://cloudopsofficial.medium.com/the-ultimate-rook-and-ceph-survival-guide-eff198a5764a)
