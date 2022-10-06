# How to use

Lifecycle
```
# start lab
vagrant up

# check status
vagrant status

# stop VMs
vagrant halt

# resume VMs
vagrant up

# destroy lab
vagrant destroy -f

# update box
vagrant box update
```
Connect to VMs
```
vagrant ssh NameOfVM
```

# Base
- [x] Vagrant
- [x] Virtual Box
- [x] [Vagrant Box Ubuntu 20.04 LTS](https://app.vagrantup.com/ubuntu/boxes/focal64)

```bash
# install plugins
vagrant plugin install --local

# optional - fix virtualbox allowed network range
# https://www.virtualbox.org/manual/ch06.html#network_hostonly
sudo mkdir /etc/vbox/
sudo bash -c 'cat <<EOF >> /etc/vbox/networks.conf
* 10.0.0.0/8 192.168.0.0/16
* 2001::/64
EOF'

```

# Lab details

You can configure the lab editing the file `.env`.
- [x] OS
- [x] Network
- [x] K8S Version
- [x] Pod network
- [x] Control plane hardware (CPU/Memory)
- [x] Number of worker nodes
- [x] Worker nodes hardware (CPU/Memory)

## Default
- Ubuntu 20.04 LTS
- Containerd as container runtime 
- Kubeadm as cluster installer
- Calico as CNI plugin


# Useful

- List kubernetes apt versions \
`curl -s https://packages.cloud.google.com/apt/dists/kubernetes-xenial/main/binary-amd64/Packages | grep Version | awk '{print $2}'`

- Print default config of kubeadm \
`kubeadm config print init-defaults`




# Start
```
vagrant up

vagrant ssh control-node
sudo -i

# CNI Calico if the node is not ready
kubectl -f /vagrant/calico/custom-resources.yaml
kubectl -f /vagrant/calico/tigera-operator.yaml

# Metrics server
kubectl apply -f /vagrant/metrics/components.yaml
kubectl top nodes
```