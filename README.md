# easy-lxc

Wrapper to make using LXC easy

This is a simple wrapper script to better facilitate using lxc.

Features:

* providing the container name alone (rather than having to insert -n when you forgot it)
* implicitly filling-in the container in simple situations
* automatically using sudo unless explicitly switched off.

## Usage

	lxctl ACTION [ CONTAINER [ OPTIONS ] ]

Most actions are mapped to their `lxc-$ACTION` equivalent, and given the arguments

As such:

	lxctl ls --fancy

Will display the fancy outptu of `lxc-ls`.

## Additional features

Still to do - port exposition. In the meantime, see notes in [exposing a container's ports out via the host](notes/container_exposure.md)

### Remember the last used container

You can run `lxctl` without specifying container or options. To provide options to the subsequent commands, you can also simply specify "." in lieu of the current container.

	lxctl create testcontainer -t ubuntu
	lxctl start
	lxctl attach . -- apt install openssh-server
	lxctl attach . -- ip a
	ssh $CONTAINERIP

	    .... you do stuff in the container .....
	
	lxctl stop
	lxctl destroy

Note that we only specified the container name in the first instance; the rest use the same container implicitly.

To see or set the last used container, run

	lxctl last
	lxctl last new-container-name

### Explicitly set a key server during `create -t download`

`lxc-create` has a defect in that it tries to query a key server on a non-officialized port when using the `download` template.

This is problematic when on a corporate LAN behind a firewall that restricts outgoing requests. When a `create` operation with `-t download` is detected, `lxctl` will attempt to fix the keyserver URL by explicitly passing the request to `hkp://keyserver.ubuntu.com:80`

* [1] [https://tools.ietf.org/html/draft-shaw-openpgp-hkp-00](https://tools.ietf.org/html/draft-shaw-openpgp-hkp-00)
* [2] [notes/gpg_hang_lxc_create.md](notes/gpg_hang_lxc_create.md)

