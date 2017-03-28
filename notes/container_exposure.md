# Exposing Containers

NOTE - these steps are notes only, as implementation research; and are unrefined. Search the wider Internet for a real solution.

It's a fairly simple task, albeit a bit unwieldy.

You need to add a rule to your iptables chain for forwarding. The raw way to do it would be:

	sudo iptables -t nat -A PREROUTING -i $myiface \
		-p tcp --dport $myext \
		-j DNAT --to-destination "$CONIP:$myint" \
		-m comment --comment "lxc on $myiface $myext:$containername:$myint"

The additional comment is useful for finding your port expositions later, both visually and programmatically, so you can modify/delete them.

Of course, if you are managing the firewall with `firewalld` or `ufw` then directly invoking iptables would NOT be the preferred way to go.

A snag though - it does not seem to be enough. Additional masquerading, and forwarding rules, seem to be needed...

Extra resources:

* [1] https://blog.simos.info/trying-out-lxd-containers-on-ubuntu-on-digitalocean/
* [2] https://help.ubuntu.com/lts/serverguide/lxc.html#lxc-network
* [3] https://blog.flameeyes.eu/2010/09/linux-containers-and-networking/

I did eventually manage to get it working in Ubuntu - some pre-requisites are already installed there...

* [4] http://askubuntu.com/questions/320121/simple-port-forwarding?rq=1

## UFW (Uncomplicated Firewall)

Typically for Ubuntu hosts. The following pulled from [StackOverflow](http://askubuntu.com/questions/370599/forward-port-to-lxc-guest-using-ufw#435286)

Add to the top of the /etc/ufw/before.rules before the *filter (top of file) (presuming you are exposing your container's port 80 to your host's port 8080 on the eth0 interface):

	*nat
	:PREROUTING ACCEPT [0:0]
	-A PREROUTING -i eth0 -p tcp --dport 8080 -j DNAT --to-destination 10.0.3.11:80 -m comment --comment "lxc on eth0 8080:containername:80"
	COMMIT

Essentially, the same as the raw command, but managed by ufw.

Then edit your `/etc/default/ufw` to use `MANAGE_BUILTINS=yes`

And finally, reload: `ufw reload` (or, `ufw disable && ufw enable`).

But this is broken at least on ubuntu. It's not yet functional as a solution so... watch [this space](http://askubuntu.com/questions/897775/lxc-port-forward-woes-with-ufw).

## FirewallD

For Fedora, Red Hat 7+, CentOS 7+ etc (note, RHEL6 and previous use plain `iptables` control out of the box), you would use FirewallD rules.

At this point, it's not anything like the raw rules, but support for that is provided via

You need to run each once for live and once for store.

	function openup {
		firewall-cmd --add-masquerade "$@"
		firewall-cmd --add-forward-port=port=80:proto=tcp:toport=8080 "$@"
	}

	openup
	openup --permanent

I have indeed noted that there are no comments here - I'll need to look into whether such are supported, or even necessary for easily finding old rules... or just use the raw command facility.

A WIP.
