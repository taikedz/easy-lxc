### LXC Wrapper Usage:help
#
# LXC Wrapper by Tai Kedzierski (C) 2016
# Released under the GPLv3 (GNU General Public License v3)
# 
# DESCRIPTION
# 
# Easy wrapper for managing LXC containers
# 
# If LXC is not installed, you will be prompted to install.
# 
# Several tasks require root permissions:
# 	* installation
# 	* adding the container name to hosts file
# 	* adding the container to IP tables forwarding rules
# 
# These are normally done automatically. To turn this off, use the '-z' option
# 
# 
# USAGE
# 
#   $(basename $0) ACTION CONTAINERNAME [OPTIONS]
# 
# ACTIONS
# 
# install
# 	install LXC if it is not yet installed
# 	offers to set up a non-privileged user
# 	run again to set up a different user
# 
# info
# 	list the details of the specirfied container
# 
# use
# 	generic action, use with modifier options
# 
# create
# 	create the named container as a new container
# 	requires a template OS name
# 
# copy
# 	make a copy of the container, requires named container and the "-to" option
# 	the default action is to clone
# 	an optional switch is the "-s" switch which will make a snapshot instead of a clone
# 
# start
# 	start the named container
# 	use the -ephemeral flag to start an ephemeral container
# 
# attach
# 	attach to the root console of the container session
# 
# ssh [-u USER] [-p PORT]
# 	connect to th named container using ssh
# 
# scp [-u USER] [-p PORT] -- FILES ...
# 	use scp to copy files to the named container.
# 
# 	  $(basename $0) scp mycontainer -u myuser -- file1 file2 dest
# 	
# 	The \`--\` token indicates the end of options for lx, and the start of the file list.
# 
# 	The \`dest\` directory is the path relative to the home of the user.
# 	Use simply "./" to copy to the in-container user home directory.
# 
# 	The above is equivalent to
# 
# 	  scp file1 file2 \$USER@\$CONTAINERIP:\$dest
# 
# stop
# 	stop the named container
# 
# destroy
# 	destroy the named container
# 
# OPTIONS
# 
# -t TEMPLATEOS
# 	for create action
# 	Name of the target OS, e.g. "ubuntu"
# -z
# 	does not run steps that require root access
# 
# -a
# 	for start and use actions
# 	attach to the console of the named container
# 
# -p PORT
# 	for ssh action
# 	use SSH to connect to the container on this port
# 
# -u USER
# 	for ssh action
# 	use SSH to connect to the container with this user
# 
# -e iface export inport
# 	operational option
# 	expose the container's port (inport) to the host's port (export) on interface (iface)
# 
# -to DESTCONTAINER
# 	specify the name of the new container to create
# 
# -s
# 	a special switch for copying, which causes the action to snapshot rather than clone
# 
# -ephemeral
# 	a speacial flag for the start operation which causes an ephmeral instance to start
# 	rather than a persistent-changes instance
###/doc 
