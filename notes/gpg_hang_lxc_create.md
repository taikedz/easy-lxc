# GPG Hangs on lxc-create

When performing `lxc-create -t download -n $NAME` fetching GPG key step hangs

Tellingly, to identify this as your issue, doing something like `lxc-create -t ubuntu -n $NAME` (explicitly setting the type) works fine.

The hang is on trying to query the keyserver when the HKP port is blocked.

Normally, receiving keys means we need to be able to query the key server using OpenPGP HKP (Hypertext Keyserver Protocol). HKP listens on TCP port 11371 historically, which is a non-standard, lesser-known port. Funnily, HKP is not even a recognized standard or accepted RFC, so good luck trying to get corporate IT to open up the firewall.

What we want for lxc-create is:

	lxc-create -t download -n $NAME -- --keyserver 'hkp://keyserver.ubuntu.com:80'


