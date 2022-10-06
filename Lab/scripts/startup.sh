#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo "--> updating /etc/hosts <--"
echo "$CONTROL_NODE_IP $CONTROL_NODE_HOSTNAME" >> /etc/hosts

for (( i=1; i<=WORKER_NODE; i++ ))
do
    echo "$WORKER_NODE_IP$i $WORKER_NODE_HOSTNAME$i" >> /etc/hosts
done


echo "--> updating <--"
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
 sysctl --system

echo "--> update and upgrade packages <--"
apt-get update -qq  && apt-get upgrade -qq -y

echo "--> install basic packages <--"
apt-get install -qq -y apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    bash-completion

echo "--> install container runtime (containerd) <--"

apt-get remove -qq -y docker docker-engine docker.io containerd runc

mkdir -p /etc/apt/keyrings 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -qq
apt-get install -qq docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

systemctl disable docker.socket
systemctl disable docker.service

systemctl stop docker.socket
systemctl stop docker.service


mkdir /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd


echo "--> install K8S packages $K8S_VERSION <--"
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

apt-get -qq update && apt-get install -qq -y kubelet=$K8S_VERSION-00 kubeadm=$K8S_VERSION-00 kubectl=$K8S_VERSION-00 && apt-mark hold kubelet=$K8S_VERSION-00 kubeadm=$K8S_VERSION-00 kubectl=$K8S_VERSION-00

echo "--> create command completion <--"
if [[ ! -f "$HOME/.once" ]]; then
    # Kubeadm
    mkdir -p ~/.kube/
    kubeadm completion bash > ~/.kube/kubeadm_completion.bash.inc
    printf "\n# Kubeadm shell completion\nsource '$HOME/.kube/kubeadm_completion.bash.inc'\n" >> $HOME/.bash_profile
    source $HOME/.bash_profile
    # Docker
    curl https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker.sh
    # Kubectl
    echo 'source <(kubectl completion bash)' >>~/.bashrc
    echo 'alias k=kubectl' >>~/.bashrc
    echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
    touch $HOME/.once
fi