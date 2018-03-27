#!/bin/bash

set -e
# set -x

BASEDIR="${HOME}/.config/VirtualBox"
# make sure output directory exists
mkdir -p $BASEDIR

# create CA certificate private key and certificate
openssl genrsa -out $BASEDIR/vrde-ca-key.pem 2048
openssl req -x509 -key $BASEDIR/vrde-ca-key.pem -nodes -out $BASEDIR/vrde-ca-cert.pem -subj '/CN=VirtualBox DEMO CA/C=AQ'

# create server key and certificate
openssl genrsa -out $BASEDIR/vrde-server-key.pem 2048
openssl req -new -key $BASEDIR/vrde-server-key.pem -out $BASEDIR/vrde-server-req.pem -subj '/CN=My VirtualBox Server/C=AQ'
openssl x509 -req -days 10000 -CA $BASEDIR/vrde-ca-cert.pem -CAkey $BASEDIR/vrde-ca-key.pem -set_serial $(date +%s%N) -in $BASEDIR/vrde-server-req.pem -out $BASEDIR/vrde-server-cert.pem

echo "Success."