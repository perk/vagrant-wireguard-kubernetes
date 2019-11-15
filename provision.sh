#!/bin/sh

set -x

export DEBIAN_FRONTEND=noninteractive 
apt-get update
apt-get -y upgrade
apt-get -y install apt-transport-https

echo "export EDITOR=vim" >> /home/vagrant/.bashrc

add-apt-repository --yes ppa:wireguard/wireguard
apt install --yes wireguard

cp /vagrant/vagrant0.vm.conf /etc/wireguard/vagrant0.conf
systemctl start wg-quick@vagrant0

snap install microk8s --classic
microk8s.status --wait-ready
ufw allow in on cbr0
ufw allow out on cbr0
ufw default allow routed

microk8s.enable dashboard
#microk8s.enable dns
# microk8s.enable fluentd
#microk8s.enable ingress
# echo N | microk8s.enable istio
# microk8s.enable jaeger
# microk8s.enable metrics-server
# microk8s.enable prometheus
microk8s.enable registry
microk8s.enable storage

# microk8s.kubectl config view --raw > $HOME/.kube/config
microk8s.kubectl config view --raw > /vagrant/.kube-config

#snap alias microk8s.docker docker
snap alias microk8s.istioctl istioctl
snap alias microk8s.kubectl kubectl

usermod -a -G microk8s vagrant

set +x
echo Dashboard IP:
kubectl -n kube-system get services | grep -i kubernetes-dashboard | awk '{print $3}'
echo

echo Dashboard token:
kubectl -n kube-system describe secret default| awk '$1=="token:"{print $2}'
echo

echo To connect to the VPN run on your local machine:
echo $ ./vpn-up.sh

# snap install docker
# snap install knctl
# snap install kubectl

# kubectl port-forward -n kube-system --address 0.0.0.0 kubernetes-dashboard-678b7d865c-kx85q 8443:8443
