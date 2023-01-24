# Редирект порта port forwarding
iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080

iptables -t mangle -A PREROUTING -p tcp --dport 8080 -j DROP

iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# DNAT port forwarding - another IP

iptables -t nat -A PREROUTING -p tcp --dport 9022 -j DNAT --to 192.168.56.6:22

iptables -A INPUT -p tcp --dport 9022 -j ACCEPT
iptables -A FORWARD -i enp0s8 -o enp0s3 -j ACCEPT

# NAT Host
echo 1 > /proc/sys/net/ipv4/ip_forward

# Edit systctl.conf for permanent changes
# MASQUERADE = auto SNAT
iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE

iptables -A FORWARD -i enp0s8 -o enp0s3 -j ACCEPT


# NAT Slave
sudo ip route add default via 192.168.56.5 dev enp0s8
