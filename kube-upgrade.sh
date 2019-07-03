#!/bin/bash

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

rm -Rf ~/.kube

## Set up host networking
modprobe overlay
modprobe br_netfilter
sysctl --system


apt-mark unhold kubelet kubeadm kubectl
apt update
# apt upgrade
apt install --only-upgrade -y kubelet kubeadm kubectl containerd.io
apt-mark hold kubelet kubeadm kubectl

## Bootstrap cluster
kubeadm init --pod-network-cidr=192.168.0.0/16


mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown -R `who am i | awk '{print $1}'` $HOME/.kube

kubectl taint nodes --all node-role.kubernetes.io/master-
