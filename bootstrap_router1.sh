#ª/user/bin/env bash

apt-get update
apt-get install inetutils-traceroute traceroute

echo "##########################"
echo "### STARTING NET CONF ####"
echo "##########################"
sudo service networking stop
sudo service networking start
sudo ip link set eth1 up
sudo ip addr add 192.168.0.1/30 dev eth1
sudo ip link set eth2 up
sudo ip addr add 172.16.1.254/24 dev eth2
sudo echo 1 >> /proc/sys/net/ipv4/ip_forward
sudo service ufw stop
sudo service apparmor teardown
sudo ip route add 192.168.1.0/30 via 192.168.0.2
sudo ip route add 192.168.2.0/30 via 192.168.0.2
sudo ip route add 172.16.0.0/24 via 192.168.0.2
sudo ip route add default via 192.168.0.2 dev eth1
sudo echo nameserver 192.168.0.2 >> /etc/resolv.conf
sudo ip route del default via 10.0.2.2 dev eth0

echo "##########################"
echo "## NETWORK CONFIGURATION #"
echo "##########################"
netconf=$(ip addr show)
echo $netconf