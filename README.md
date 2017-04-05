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

Will display the fancy output of `lxc-ls`.

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

The download template has a defect in that it tries to query a key server on a non-officialized port.

This is problematic when on a corporate LAN behind a firewall that restricts outgoing requests. When the use of the `download` template is detected, `lxctl` will attempt to fix the keyserver URL by explicitly passing the request to `hkp://p80.pool.sks-keyservers.com:80`. You can override this in your environment by setting the `DOWNLOAD_KEYSERVER` variable. This has been merged upstream [3]

* [1] [https://tools.ietf.org/html/draft-shaw-openpgp-hkp-00](https://tools.ietf.org/html/draft-shaw-openpgp-hkp-00)
* [2] [notes/gpg_hang_lxc_create.md](notes/gpg_hang_lxc_create.md)
* [3] [https://github.com/lxc/lxc/pull/1473](https://github.com/lxc/lxc/pull/1473)

