#!/bin/bash

cp /vagrant/shared/join.sh /tmp/
chmod +x /tmp/join.sh

/bin/bash /tmp/join.sh

echo "--> kube config <--"

mkdir -p $HOME/.kube
cp -i /vagrant/shared/kubeconfig $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config


mkdir -p /home/vagrant/.kube
sudo cp -i /vagrant/shared/kubeconfig /home/vagrant/.kube/config
sudo chown $(id vagrant -u):$(id vagrant -g) /home/vagrant/.kube/config
