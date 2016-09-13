#/bin/sh

IP_LAN="192.168.0.1"
IP_DMZ="192.168.1.1"
IF_EXT="eth2"
IF_LAN="eth0"
IF_DMZ="eth1"
DMZ_HTTP="192.168.1.2"
DMZ_DNS="192.168.1.3"
DMZ_MAIL="192.168.1.4"
IPT="/usr/sbin/iptables"
## path to iptables binary

## Enable IP forwarding
echo "1" » /proc/sys/net/ipv4/ip_forward

## Enable dynamic Ips
echo "1" » /proc/sys/net/ipv4/ip_dynaddr

## Helper modules
/sbin/modprobe ip_conntrack_ftp
/sbin/modprobe ip_nat_ftp
for f in /proc/sys/net/ipv4/conf/*/accept_source_route; do
echo 0 » $f
done
for f in /proc/sys/net/ipv4/conf/*/rp_filter; do
echo 1 » $f
done
for f in /proc/sys/net/ipv4/conf/*/accept_redirects; do
echo 0 » $f
done
for f in /proc/sys/net/ipv4/conf/*/secure_redirects; do
echo 1 » $f
done
for f in /proc/sys/net/ipv4/conf/*/send_redirects; do
echo 0 » $f
done
echo 1 » /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
echo 1 » /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses
for f in /proc/sys/net/ipv4/conf/*/log_martians; do
echo 1 » $f
done
echo 200 » /proc/sys/net/ipv4/icmp_ratelimit
echo 1 » /proc/sys/net/ipv4/tcp_syncookies
echo 256 » /proc/sys/net/ipv4/tcp_max_syn_backlog

$IPT -flush
$IPT -t nat -flush
$IPT -t mangle -flush
$IPT -X

## Allow loopback traffic
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A OUTPUT -o lo -j ACCEPT

## Default chain policies
$IPT -P INPUT DROP
$IPT -P OUTPUT DROP
$IPT -P FORWARD DROP

$IPT -t nat -A POSTROUTING -o $IF_EXT -j MASQUERADE
$IPT -A FORWARD -i $IF_LAN -o $IF_EXT -m state \
--state NEW,ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -i $IF_EXT -o $IF_LAN -m state \
--state ESTABLISHED,RELATED -j ACCEPT
$IPT -A INPUT -m state \
--state ESTABLISHED,RELATED -j ACCEPT
$IPT -A OUTPUT -m state \
--state NEW,ESTABLISHED,RELATED -j ACCEPT

$IPT -t nat -A PREROUTING -p tcp -i $IF_EXT ---dport 80 \
-j DNAT --to-destination $DMZ_HTTP
$IPT -t nat -A PREROUTING -p tcp -i $IF_EXT ---dport 443 \
-j DNAT --to-destination $DMZ_HTTP
$IPT -t nat -A PREROUTING -p tcp -i $IF_EXT ---dport 53 \
-j DNAT --to-destination $DMZ_DNS
$IPT -t nat -A PREROUTING -p udp -i $IF_EXT ---dport 53 \
-j DNAT --to-destination $DMZ_DNS
$IPT -t nat -A PREROUTING -p tcp -i $IF_EXT ---dport 25 \
-j DNAT --to-destination $DMZ_MAIL

$IPT -A FORWARD -i $IF_DMZ -o $IF_EXT -j ACCEPT
$IPT -A FORWARD -i $IF_EXT -o $IF_DMZ -m state \
--state ESTABLISHED,RELATED -j ACCEPT

$IPT -A FORWARD -p tcp -i $IF_EXT -o $IF_DMZ -d $DMZ_HTTP \
--dport 80 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -p tcp -i $IF_EXT -o $IF_DMZ -d $DMZ_HTTP \
--dport 443 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -p tcp -i $IF_EXT -o $IF_DMZ -d $DMZ_DNS \
--dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -p udp -i $IF_EXT -o $IF_DMZ -d $DMZ_DNS \
--dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -p tcp -i $IF_EXT -o $IF_DMZ -d $DMZ_MAIL \
--dport 25 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

$IPT -A FORWARD -i $IF_DMZ -o $IF_LAN -m state ---state \
ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -i $IF_LAN -o $IF_DMZ \
-m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -p tcp -i $IF_LAN -o $IF_DMZ -d $DMZ_HTTP \
--dport 80 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -p tcp -i $IF_LAN -o $IF_DMZ -d $DMZ_HTTP \
--dport 443 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -p tcp -i $IF_LAN -o $IF_DMZ -d $DMZ_DNS \
--dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -p udp -i $IF_EXT -o $IF_DMZ -d $DMZ_DNS \
--dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -p tcp -i $IF_LAN -o $IF_DMZ -d $DMZ_MAIL \
--dport 25 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

echo "NAT firewall started"