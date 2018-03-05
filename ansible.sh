#!/bin/sh

ansible=ansible-2.4.3.0.tar.gz
ansible_dir=${ansible%\.*}
ansible_dir=${ansible_dir%\.*}

topdir=$(cd `dirname $0`; pwd)

function system_is_redhat() {
	grep "Red Hat" /etc/redhat-release > /dev/null 2>&1
}

function install_dependencies() {
	if system_is_redhat; then
		yum -y install \
			rpm-build \
			make \
			python2-devel \
			> /dev/null
	fi
}

function build_ansible() {
	if [ ! -d $ansible_dir ]; then
		if [ ! -f $ansible ]; then
			local ansible_url=http://releases.ansible.com/ansible/ansible-2.4.3.0.tar.gz
			wget $ansible_url
		fi
		tar xf $ansible
	fi
	ansible_path=$topdir/$ansible_dir

	if grep ANSIBLE_PATH prfole > /dev/null 2>&1; then
		return
	fi
	echo "export ANSIBLE_PATH=$ansible_path" >> profile
	echo "export PATH=$ansible_path/bin:$PATH" >> profile
}

#----------------------------------------------------

if [ "$1" = "-f" ]; then
	echo "exec function $2"
	$2
	exit
fi
