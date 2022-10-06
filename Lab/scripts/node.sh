#!/bin/bash

cp /vagrant/shared/join.sh /tmp/
chmod +x /tmp/join.sh

/bin/bash /tmp/join.sh

echo "--> kube config <--"

mkdir -p $HOME/.kube
cp -f /vagrant/shared/kubeconfig $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config


mkdir -p /home/vagrant/.kube
sudo cp -f /vagrant/shared/kubeconfig /home/vagrant/.kube/config
sudo chown $(id vagrant -u):$(id vagrant -g) /home/vagrant/.kube/config


echo "--> approve certificates <--"
sleep 5
kubectl get csr | grep Pending | cut -f1 -d" " | xargs kubectl certificate approve
