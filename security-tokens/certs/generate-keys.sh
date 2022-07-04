#!/bin/bash

set -e 

DAYS=3650
OPENSSL=openssl

read -p "This will overwrite existing files, continue (y/n)? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	rm -f spcb-root-ca.key spcb-root-ca.crt spcb-root-ca-key.pem
	echo "Generate EC key and root certificate for 'South Pole Central Bank'"
	$OPENSSL ecparam -name prime256v1 -genkey -out spcb-root-ca-key.pem
	$OPENSSL req -new -x509 -batch -days $DAYS -key spcb-root-ca-key.pem -subj '/C=AQ/O=South Pole Central Bank/CN=SPCB ROOT CA' -out spcb-root-ca.crt -outform DER
	$OPENSSL ec -in spcb-root-ca-key.pem -outform DER -out spcb-root-ca.key

	rm -f aqts-root-ca.pem aqts-root-ca.key aqts-root-ca.crt
	echo "Generate RSA key and root certificate for 'Antarctic Tax Service'"
	$OPENSSL genrsa -out aqts-root-ca.pem 2048
	$OPENSSL rsa -in rsa -in aqts-root-ca.pem -outform DER -out aqts-root-ca.key
	rm aqts-root-ca.pem
	$OPENSSL req -new -x509 -batch -days $DAYS -keyform DER -key aqts-root-ca.key -subj '/C=AQ/O=Antarctic Tax Service/CN=AQTS ROOT CA' -out aqts-root-ca.crt -outform DER

	#openssl genrsa -out rsa2048_user.pem 2048
	#openssl req -new -x509 -batch -days 1000 -key rsa2048_user.pem -subj '/C=RU/1.2.643.100.4=1111111111/2.5.4.3=Ivanov Ivan' -out user.crt
else
	echo "Exiting without modification."
fi


