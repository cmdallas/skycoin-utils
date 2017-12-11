#!/usr/bin/env bash

hostname=$1
ip=$2
netmask=$3
gateway=$4

systemctl > /dev/null 2>&1
echo "NETWORKING=yes" > /etc/sysconfig/network

echo -e "\e[36m== Blacklisting wifi/bluetooth ==\e[0m"
cat > /etc/modprobe.d/raspi-blklst.conf <<EOL
#wifi
blacklist brcmfmac
blacklist brcmutil
#bt
blacklist btbcm
blacklist hci_uart
EOL

yum -y remove NetworkManager NetworkManager-libnm firewalld
yum -y update yum
yum -y install iptables-services ruby gem vim yum-utils deltarpm tmux
systemctl enable iptables
yum update -y

echo -e "\e[36m== Assigning static IP address ==\e[0m"
cat >> /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOL
DEVICE=eth0
TYPE=Ethernet
BOOTPROTO=none
ONBOOT=yes
IPADDR=$ip
NETMASK=$netmask
GATEWAY=$gateway
EOL
echo -e "\e[32m   Done\e[0m"
echo ""

echo -e "\e[36m== Configuring hostname and timezone ==\e[0m"
hostnamectl set-hostname $hostname
timedatectl set-timezone America/Los_Angeles
echo -e "\e[32m   Done\e[0m"
echo ""

echo -e "\e[36m== Installing Golang ==\e[0m"
wget https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz
tar -xvf go1.9.2.linux-amd64.tar.gz
mv go /usr/local
echo ""

echo -e "\e[36m== Setting GO[PATH,ROOT] & PATH ==\e[0m"
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

go version
go env
echo ""

echo -e "\e[36m== Installing Skywire components ==\e[0m"
cd ${GOPATH}/src/github.com
mkdir skycoin && cd $_
git clone -b dev https://github.com/skycoin/skywire.git
cd $GOPATH/src/github.com/skycoin/skywire/cmd
go install ./...
echo ""

echo -e "\e[36m== Finished! ==\e[0m"
echo -e "\e[32m== Rebooting ==\e[0m"
reboot
