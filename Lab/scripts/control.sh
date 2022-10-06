#!/bin/bash

echo "--> replace kubeadm config file <--"

cp -f /vagrant/kubeadm/config.yaml /vagrant/shared/kubeadm-config.yaml
sed -i "s/CONTROL_NODE_IP/$CONTROL_NODE_IP/g" /vagrant/shared/kubeadm-config.yaml
sed -i "s:K8S_POD_NET_CIDR:$K8S_POD_NET_CIDR:g" /vagrant/shared/kubeadm-config.yaml

echo "--> kube init <--"

kubeadm init --config=/vagrant/shared/kubeadm-config.yaml

echo "--> kube config <--"

mkdir -p $HOME/.kube
sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


mkdir -p /home/vagrant/.kube
sudo cp -f /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown $(id vagrant -u):$(id vagrant -g) /home/vagrant/.kube/config

sudo cp -f /etc/kubernetes/admin.conf /vagrant/shared/kubeconfig

echo "--> approve certificates <--"
kubectl get csr | grep Pending | cut -f1 -d" " | xargs kubectl certificate approve

echo "--> install calico <--"

kubectl apply -f /vagrant/calico/tigera-operator.yaml

kubectl apply -f /vagrant/calico/custom-resources.yaml

echo "--> create kubeadm join <--"

join=$(kubeadm token create --print-join-command)

cat << EOF > /vagrant/shared/join.sh
#!/bin/bash
$join --cri-socket unix:///var/run/containerd/containerd.sock
EOF

chmod +x /vagrant/shared/join.sh -v