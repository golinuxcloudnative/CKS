#!/bin/bash

echo "--> kube init <--"

kubeadm init --apiserver-advertise-address=$CONTROL_NODE_IP --pod-network-cidr=$K8S_POD_NET_CIDR --cri-socket unix:///var/run/containerd/containerd.sock
    
    

echo "--> kube config <--"

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown $(id vagrant -u):$(id vagrant -g) /home/vagrant/.kube/config

sudo cp -i /etc/kubernetes/admin.conf /vagrant/shared/kubeconfig

echo "--> install calico <--"

kubectl create -f /vagrant/calico/tigera-operator.yaml

kubectl create -f /vagrant/calico/custom-resources.yaml

echo "--> create kubeadm join <--"

join=$(kubeadm token create --print-join-command)

cat << EOF > /vagrant/shared/join.sh
#!/bin/bash
$join --cri-socket unix:///var/run/containerd/containerd.sock
EOF


chmod +x /vagrant/shared/join.sh -v