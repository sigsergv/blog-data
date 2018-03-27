#!/bin/bash

# Enable secure RDP on specified virtual machine

VM=$1

# login user name
VM_USER=$2

# password hash is calculated by command `VBoxManage internalcommands passwordhash "SECRET_PASSWORD"`
PASS_HASH=$3

# RDP port
RDP_PORT=$4

if test -z "$RDP_PORT" ; then
    echo "Usage:"
    echo "    $0 VM VM_USER PASS_HASH RDP_PORT"
    exit 1
fi

exit 123

VBoxManage modifyvm $VM --vrdeauthtype external
VBoxManage setextradata $VM "VBoxAuthSimple/users/${VM_USER}" $PASS_HASH

VBoxManage modifyvm $VM --vrdeproperty "Security/Method=tls"
VBoxManage modifyvm $VM --vrdeproperty "Security/CACertificate=${HOME}/.config/VirtualBox/vrde-ca-cert.pem"
VBoxManage modifyvm $VM --vrdeproperty "Security/ServerCertificate=${HOME}/.config/VirtualBox/vrde-server-cert.pem"
VBoxManage modifyvm $VM --vrdeproperty "Security/ServerPrivateKey=${HOME}/.config/VirtualBox/vrde-server-key.pem"

VBoxManage modifyvm $VM --vrde on --vrdeport $RDP_PORT