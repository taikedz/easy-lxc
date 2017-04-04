# Exposing LXC Containers

It's a fairly simple task, albeit a bit unwieldy. As a one-time setup, you will need to ensure that the following get set (tyipically at startup)

	iptables -A FORWARD -o lxcbr0 -j ACCEPT
	iptables -A FORWARD -i lxcbr0 -j ACCEPT
	
	iptables -A INPUT -p udp --dport 53 -i enp0s8 -m state --state NEW -j ACCEPT
	iptables -A INPUT -p tcp --dport 53 -i enp0s8 -m state --state NEW -j ACCEPT
	iptables -A INPUT -p udp --dport 67 -i enp0s8 -m state --state NEW -j ACCEPT
	iptables -A INPUT -p tcp --dport 67 -i enp0s8 -m state --state NEW -j ACCEPT
	
	iptables -t nat -A POSTROUTING -s 10.0.3.0/24 ! -d 10.0.3.0/24 -j MASQUERADE

To do the actual host-guest forwarding, you then need to add a rule to your iptables chain for forwarding. The raw way to do it would be:

	sudo iptables -t nat -A PREROUTING -i $myiface \
		-p tcp --dport $myext \
		-j DNAT --to-destination "$CONIP:$myint" \
		-m comment --comment "lxc on $myiface $myext:$containername:$myint"

The additional comment is useful for finding your port expositions later, both visually and programmatically, so you can modify/delete them.

## UFW (Uncomplicated Firewall)

You need to ensure the following is applied in UFW (presuming you are exposing your container's port 80 to your host's port 8080 on the eth0 interface):

At the top of `/etc/ufw/before.rules`, before the `*filter` section

	*nat
	:PREROUTING ACCEPT [0:0]
	-A PREROUTING -i eth0 -p tcp --dport 8080 -j DNAT --to 10.0.3.101:80
	COMMIT

Note that with LXD you should be able to stop here. With regular LXC however, the following is also required:

Near the bottom, before the final commit:

	-A FORWARD -o lxcbr0 -j ACCEPT
	-A FORWARD -i lxcbr0 -j ACCEPT
	
	-A INPUT -p udp --dport 53 -i eth0 -m state --state NEW -j ACCEPT
	-A INPUT -p tcp --dport 53 -i eth0 -m state --state NEW -j ACCEPT
	-A INPUT -p udp --dport 67 -i eth0 -m state --state NEW -j ACCEPT
	-A INPUT -p tcp --dport 67 -i eth0 -m state --state NEW -j ACCEPT

At the top of `/etc/ufw/after.rules`, before the `*filter` section

	*nat
	:POSTROUTING ACCEPT [0:0]
	-A POSTROUTING -s 10.0.3.0/24 ! -d 10.0.3.0/24 -j MASQUERADE
	COMMIT


And finally, reload: `ufw reload` (or, `ufw disable && ufw enable`).

## FirewallD

I have no notes on doing this on a Fedora host.

Not sure what we'd be forwarding to in this instance, as LXC/LXD is not typically deployed on Fedora and derivatives.
