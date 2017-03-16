# Exposing Containers

It's a fairly simple task, albeit a bit unwieldy.

You need to add a rule to your iptables chain for forwarding. The raw way to do it would be:

	sudo iptables -t nat -A PREROUTING -i $myiface -p tcp --dport $myext -j DNAT --to "$CONIP:$myint" -m comment --comment "lxc containerName PORTNUM"

The additional comment is useful for finding your port expositions later, both visually and programmatically.

Of course, if you are managing the firewall with `firewalld` or `ufw` then directly invoking iptables would NOT be the preferred way to go.

## UFW (Uncomplicated Firewall)

Typically for Ubuntu hosts. The following pulled from [StackOverflow](http://askubuntu.com/questions/370599/forward-port-to-lxc-guest-using-ufw#435286)

Add to the top of the /etc/ufw/before.rules before the *filter (top of file) (presuming you are exposing your ctonainer's port 80 to your host's port 8080 on the eth0 interface):

	*nat
	:PREROUTING ACCEPT [0:0]
	-A PREROUTING -i eth0 -p tcp --dport 8080 -j DNAT --to 10.0.3.11:80 -m comment --comment "lxc containername 8080:80"
	COMMIT

Then edit your `/etc/default/ufw` to use `MANAGE_BUILTINS=yes`

And finally, reload: `ufw reload` (or, `ufw disable && ufw enable`).

## FirewallD

For Fedora, Red Hat 7+, CentOS 7+ etc (note, RHEL6 and previous use plain `iptables` control out of the box), you would use FirewallD rules.

You need to run once for live and once for store, though that second one might need to be changed after a reboot. YMMV.

	function openup {
		firewall-cmd --add-masquerade "$@"
		firewall-cmd --add-forward-port=port=80:proto=tcp:toport=8080 "$@"
	}

	openup
	openup --permanent
