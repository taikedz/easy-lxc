# easy-lxc

Wrapper to make using LXC easy

## About

This project supplies a single `lx` command, a bash script, through which you can perform installation of LXC, and set up un-privileged users.

Additionally, the `lx` command allows you to

* Create new containers
* start containers and automatically
	* assign a local `/etc/hosts` entry based on the container's name
	* expose a container's ports to an interface + port on the host
* stop and destry containers
* clone containers

Future goals are to enable it to

* manage the NAT traversal more fully
	* allow specifying port exposition rules for the container
	* adding and removing rules on start/stop of the container automatically
* add more management to unprivileged users
	* re-configure un-privileged users' quotas
	* remove un-privilieged users
	* configure containers for a nobody user (?)
* move containers between users

## Usage

Copy the `bin/lx` command to an appropriate location (suggestion: `/usr/local/bin`)

Run with root permissions to install lxc

	lx install

You will be asked whether to set up an unprivileged user to be able to use lxc and create containers.

To add more users, run `lxc install` again.

For container operations, the first argument must be the action, the second must be the name of the container to operate on.

Create a new container with

	lx create mycontainer

Start and stop containers

	lx start mycontainer
	lx stop mycontainer

Starting and stopping containers will automatically try to add an appropriately-named entry to the /etc/hosts file. This requires sudo ability. To suppress this, run instead

	lx start mycontainer -z
	lx stop mycontainer -z

You can connect to the container using either the attach command to get a root session

	lx attach mycontainer

or the ssh command to ssh to the container (if an ssh is installed and running on the container)

	lx ssh mycontainer
	lx ssh mycontainer -u user
	lx ssh mycontainer -u user -p port

Other commands are also available. See `lx --help` for more info.
