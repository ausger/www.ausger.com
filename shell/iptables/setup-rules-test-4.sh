# allow ssh connections before you lock out everybody lol
# keep in mind if you do anything wrong, you can now just reboot
# clear all rules and start with blocking all traffic

iptables -F && iptables -P INPUT ACCEPT && iptables -P OUTPUT ACCEPT && iptables -P FORWARD ACCEPT

### Add your rules form the link above, here
# ssh,smtp,imap,http,https,pop3,imaps,pop3s
iptables -A INPUT -i eth0 -p tcp -m multiport --dports 22,25,143,80,443,110,993,995 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp -m multiport --sports 22,25,143,80,110,443,993,995 -m state --state NEW,ESTABLISHED -j ACCEPT

## allow dns
iptables -A OUTPUT -p udp -o eth0 --dport 53 -j ACCEPT && iptables -A INPUT -p udp -i eth0 --sport 53 -j ACCEPT

# handling pings
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT && iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT

iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT && iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT

# manage ddos attacks
iptables -A INPUT -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT

## Implement some logging so that we know what's getting dropped

iptables -N LOGGING
iptables -A INPUT -j LOGGING
iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "IPTables Packet Dropped: " --log-level 7
iptables -A LOGGING -j DROP

# once a rule affects traffic then it is no longer managed
# so if the traffic has not been accepted, block it
iptables -A INPUT -j DROP
iptables -I INPUT 1 -i lo -j ACCEPT
iptables -A OUTPUT -j DROP

# allow only internal port forwarding
iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
iptables -P FORWARD DROP

# create an iptables config file
iptables-save > /root/dsl.fw

vi /etc/rc.local
/sbin/iptables-restore < /root/dsl.fw

/etc/init.d/iptables save

## check to see if this setting is working great.
service iptables restart