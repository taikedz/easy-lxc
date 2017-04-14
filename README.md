# easy-lxc

Wrapper to make using LXC easy

This is a simple wrapper script to better facilitate using lxc.

Features:

* providing the container name alone (rather than having to insert -n when you forgot it)
* implicitly filling-in the container in simple situations
* automatically using sudo unless explicitly switched off.

## Installation

	git clone https://github.com/taikedz/easy-lxc
	cd easy-lxc
	git checkout v2.1
	sudo ./install

## Usage

	lx ACTION [ CONTAINER [ OPTIONS ] ]

Most actions are mapped to their `lxc-$ACTION` equivalent, and given the arguments

As such:

	lx ls --running

will display specifically the running containers.

## Additional features

Still to do - port exposition. In the meantime, see notes in [exposing a container's ports out via the host](notes/container_exposure.md)

### Remember the last used container

You can run `lx` without specifying container or options. To provide options to the subsequent commands, you can also simply specify "." in lieu of the current container.

	lx create testcontainer -t ubuntu
	lx start
	lx attach . -- apt install openssh-server
	lx attach . -- ip a
	ssh $CONTAINERIP

	    .... you do stuff in the container .....
	
	lx stop
	lx destroy

Note that we only specified the container name in the first instance; the rest use the same container implicitly.

To see last used container, run

	lx last

To set last used container, run

	lx last new-container-name

### Automatic inference of container name

You can optionally type just a substring of a container to use it -- say you have 3 containers

	project
	project-live
	project-test

You can run

* `lx attach project` to attach to the "project" container
* `lx start test` to run the "project-test" container

But you cannot perform any action on a `projec` container - it is neither a strict match, nor does it match a single container name.

Note that this auto-inference does NOT work for `destroy` and `create` commands.

### Defaults

You can set defaults in your `$HOME/.config/lxctl/defaults` file. Each line contains a command followed by a list of options. Use `{}` to signal where the runtime command line arguments should be inserted.

For example, a defaults file with the contents

	create -t download {} -- -a amd64
	ls --fancy

would cause the download template to always choose amd64 as its architecture, and always cause the `ls` command to list in fancy mode.

### Explicitly set a key server during `create -t download`

The download template has a defect in that it tries to query a key server on a non-officialized [1] port.

For this reason, a keyserver is pre-configured in the defaults file.

* [1] [https://tools.ietf.org/html/draft-shaw-openpgp-hkp-00](https://tools.ietf.org/html/draft-shaw-openpgp-hkp-00)

