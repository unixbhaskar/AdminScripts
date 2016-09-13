#/bin/sh
IF_LAN="eth1"
IF_DMZ="eth2"
IF_EXT="eth0"
IP_LAN="192.168.1.1"
IP_DMZ="192.168.0.1"
DMZ_HTTP="192.168.0.3"
DMZ_DNS="192.168.0.2"
DMZ_MAIL="192.168.0.4"

## The exact path to the iptables binary varies between Linux
## distributions.
IPT="/usr/local/sbin/iptables"

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
for f in /proc/sys/net/ipv4/conf/*/rp_filter; do echo 1 » $f
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

## LAN «-» EXT
$IPT -t nat -A POSTROUTING -o $IF_EXT -j MASQUERADE
$IPT -A FORWARD -i $IF_LAN -o $IF_EXT -m state \
--state NEW,ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -i $IF_EXT -o $IF_LAN -m state \
--state ESTABLISHED,RELATED -j ACCEPT
## By default, no NEW connections to or from the firewall
$IPT -A INPUT -m state \
--state ESTABLISHED,RELATED -j ACCEPT
$IPT -A OUTPUT -m state \
--state ESTABLISHED,RELATED -j ACCEPT
## DNAT for EXT -» DMZ
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

## Default forwarding for EXT «-» DMZ is
## ESTABLISHED and RELATED only

$IPT -A FORWARD -i $IF_DMZ -o $IF_EXT -m state \
--state ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -i $IF_EXT -o $IF_DMZ -m state \
--state ESTABLISHED,RELATED -j ACCEPT

## .. make exceptions for the following services, and allow NEW:
$IPT -A FORWARD -p tcp -i $IF_EXT -o $IF_DMZ -d $DMZ_HTTP \
--dport 80 -m state -- state NEW,ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -p tcp -i $IF_EXT -o $IF_DMZ -d $DMZ_HTTP \
--dport 443 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -p tcp -i $IF_EXT -o $IF_DMZ -d $DMZ_DNS \
--dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -p udp -i $IF_EXT -o $IF_DMZ -d $DMZ_DNS \
--dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -p tcp -i $IF_EXT -o $IF_DMZ -d $DMZ_MAIL \
--dport 25 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

## DMZ «-» LAN
$IPT -A FORWARD -i $IF_DMZ -o $IF_LAN -m state -state \
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


##

$IPT -A INPUT -m state \
--state ESTABLISHED,RELATED -j ACCEPT
$IPT -A OUTPUT -m state \
--state ESTABLISHED,RELATED -j ACCEPT

## Allow the firewall machine access to the
## nameserver inside the DMZ
$IPT -A OUTPUT -o $IF_DMZ -p udp -d $DMZ_DNS ---dport 53 \
--sport 1024:65535 -j ACCEPT
$IPT -A OUTPUT -o $IF_DMZ -p tcp -d $DMZ_DNS ---dport 53 \
--sport 1024:65535 -j ACCEPT

## Limit SSH access to individual machines inside the LAN
$IPT -A INPUT -i $IF_LAN -p tcp ---dport 22 \
-s 192.168.1.37 -j ACCEPT

## The following rules allow DHCP traffic
$IPT -A OUTPUT -o $IF_EXT -p udp ---sport 68 ---dport 67 \
-d 255.255.255.255 -j ACCEPT
$IPT -A INPUT -i $IF_EXT -p udp ---sport 67 ---dport 68 \
-s 255.255.255.255 -j ACCEPT
$IPT -A INPUT -i $IF_EXT -p udp ---sport 67 ---dport 68 \
-s «IP of DHCP server» -j ACCEPT
## Limit traffic flow to and from the DMZ nameserver
$IPT -I FORWARD -o $IF_DMZ -d $DMZ_DNS -p udp \
--sport 1024:65535 --dport 53 -j ACCEPT
$IPT -I FORWARD -o $IF_DMZ -d $DMZ_DNS -p udp \
--sport 53 --dport 53 -j ACCEPT

$IPT -I FORWARD -o $IF_DMZ -d $DMZ_DNS -p udp \
--sport 53 --dport 1024:65535 -j ACCEPT

$IPT -I FORWARD -o $IF_DMZ -d $DMZ_DNS -p tcp \
--sport 1024:65535 --dport 53 -j ACCEPT

$IPT -I FORWARD -o $IF_DMZ -d $DMZ_DNS -p tcp \
--sport 53 --dport 53 -j ACCEPT

$IPT -I FORWARD -o $IF_DMZ -d $DMZ_DNS -p tcp ---sport 53 \
--dport 1024:65535 -j ACCEPT

## Limit traffic flowing to and from the DMZ mail server
$IPT -I FORWARD -o $IF_DMZ -d $DMZ_MAIL -p tcp \
--sport 23 --dport 1024:65535 -j ACCEPT

$IPT -I FORWARD -o $IF_DMZ -d $DMZ_MAIL -p tcp \
--sport 1024:65535 --dport 1024:65535 -j ACCEPT

## Limit and log ICMP traffic
$IPT -I INPUT -p icmp --icmp-type echo-request \
-m limit --limit 180/minute -j ACCEPT

$IPT -I INPUT -p icmp --icmp-type ! Echo-request \
-m limit --limit 180/minute -j ACCEPT

$IPT -I INPUT -p icmp -m limit --limit 50/minute -j LOG

## Rewrite the TTL on packets leaving the local network
## the -j TTL target is generally not enabled in many kernels, so
## this option is disabled by default.
#$IPT -A FORWARD -o $IF_EXT -j TTL ---ttl-set 64

## Addresses or hostnames contained in the file
## /usr/local/etc/hosts.deny are dropped.
for host in 'cat /usr/local/etc/hosts.deny'; do
$IPT -I INPUT -s $host -j DROP
$IPT -I FORWARD -s $host -j DROP
$IPT -I OUTPUT -d $host -j DROP
$IPT -I FORWARD -d $host -j DROP
done

## A user-defined chain for picking up "bad" packets - those with
## illegal IP addresses. Logging such packets is useful for
## troubleshooting incorrectly configured applications, but may
## cause large log files.

$IPT -N bad_packets
$IPT -P bad_packets ACCEPT

$IPT -A bad_packets -s 10.0.0.0/8 -j LOG \
--log-prefix "illegal_source_address"
$IPT -A bad_packets -s 10.0.0.0/8 -j DROP

$IPT -A bad_packets -s 172.16.0.0/12 -j LOG \
--log-prefix "illegal_source_address"
$IPT -A bad_packets -s 172.16.0.0/12 -j DROP

## Addresses in the 192.168.0.0 - 192.168.0.255 range are
## only valid when originating from the DMZ
$IPT -A bad_packets -i $IF_EXT -s 192.168.0.0/24 -j LOG \
--log-prefix "illegal_source_address"
$IPT -A bad_packets -i $IF_EXT -s 192.168.0.0/24 -j DROP

$IPT -A bad_packets -i $IF_LAN -s 192.168.0.0/24 -j LOG \
--log-prefix "illegal_source_address"
$IPT -A bad_packets -i $IF_LAN -s 192.168.0.0/24 -j DROP

## Addresses in the 192.168.1.0 - 192.168.1.255 range are
## only valid when originating from the LAN
$IPT -A bad_packets -i $IF_EXT -s 192.168.1.0/24 -j LOG \
--log-prefix "illegal_source_address"
$IPT -A bad_packets -i $IF_EXT -s 192.168.1.0/24 -j DROP

$IPT -A bad_packets -i $IF_DMZ -s 192.168.1.0/24 -j LOG \
-log-prefix "illegal_source_address"
$IPT -A bad_packets -i $IF_DMZ -s 192.168.1.0/24 -j DROP
## Reserved, multicast, broadcast, and loopback addresses
$IPT -A bad_packets -s 169.254.0.0/16 -j LOG \
--log-prefix "illegal_source_address"
$IPT -A bad_packets -s 169.254.0.0/16 -j DROP

$IPT -A bad_packets -s 192.0.2.0/16 -j LOG \
--log-prefix "illegal_source_address"
$IPT -A bad_packets -s 192.0.2.0/16 -j DROP

$IPT -A bad_packets -s 0.0.0.0/8 -j LOG \
--log-prefix "illegal_source_address"
$IPT -A bad_packets -s 0.0.0.0/8 -j DROP

$IPT -A bad_packets -s 224.0.0.0/4 -j LOG \
--log-prefix "illegal_source_address"
$IPT -A bad_packets -s 224.0.0.0/4 -j DROP

$IPT -A bad_packets -s 240.0.0.0/5 -j LOG \
--log-prefix "illegal_source_address"
$IPT -A bad_packets -s 240.0.0.0/5 -j DROP

$IPT -A bad_packets -s 127.0.0.0/8 -j LOG \
-log-prefix "illegal_source_address"
$IPT -A bad_packets -s 127.0.0.0/8 -j DROP

## Generally packets destined to the broadcast
## address 255.255.255.255 should be dropped
$IPT -A bad_packets -d 255.255.255.255 -j LOG \
--log-prefix "illegal_dest_address"

$IPT -A bad_packets -d 255.255.255.255 -j DROP

## If you have a static IP address, the following rules will
## log and drop broadcast packets. The destination IP addresses
## should be changed to reflect your IP.
# $IPT -A bad_packets -d 1.2.3.0 -j LOG -log-prefix "broadcast"
# $IPT -A bad_packets -d 1.2.3.0 -j DROP
# $IPT -A bad_packets -d 1.2.3.255 -j LOG -log-prefix "broadcast"
# $IPT -A bad_packets -d 1.2.3.255 -j DROP

$IPT -I INPUT -j bad_packets
$IPT -I OUTPUT -j bad_packets
$IPT -I FORWARD -j bad_packets

echo "Firewall started"