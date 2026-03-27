#!/bin/bash
set -e

yum update -y

# Install OpenVPN
yum install -y openvpn easy-rsa

# Setup PKI
mkdir -p /etc/openvpn/easy-rsa
cp -r /usr/share/easy-rsa/* /etc/openvpn/easy-rsa/
cd /etc/openvpn/easy-rsa

./easyrsa init-pki
echo | ./easyrsa build-ca nopass
./easyrsa gen-req server nopass
echo yes | ./easyrsa sign-req server server
./easyrsa gen-dh

# Copy certs
cp pki/ca.crt pki/private/server.key pki/issued/server.crt pki/dh.pem /etc/openvpn/

# Basic config
cat > /etc/openvpn/server.conf <<EOF
port 1194
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
server 10.8.0.0 255.255.255.0
keepalive 10 120
persist-key
persist-tun
status openvpn-status.log
verb 3
EOF

# Enable IP forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# Start OpenVPN
systemctl start openvpn@server
systemctl enable openvpn@server