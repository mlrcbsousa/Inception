#!/bin/bash

# https://www.digicert.com/kb/csr-ssl-installation/nginx-openssl.htm
# https://mcilis.medium.com/how-to-create-a-server-certificate-with-configuration-using-openssl-ea3d2c4506ac
# https://www.switch.ch/pki/manage/request/csr-openssl/
# https://www.openssl.org/docs/man1.1.1/man5/x509v3_config.html

DOMAIN=$1
DOMAIN_IP=$2

CA_CERTIFICATE=$3_CA.crt
CA_PRIVATE_KEY=$3_CA.key

SERVER_CERTIFICATE=$3.crt
SERVER_PRIVATE_KEY=$3.key
SERVER_SIGN_REQUEST=$3.csr

CONFIG_SIGN_REQUEST=csr.conf
CONFIG_EXTENSION=cert.conf

# Generates a root certificate authority (CA) using OpenSSL, using a 2048-bit
# RSA key, with a validity period of 356 days, with the specified subject
# information: "/CN=msousa/C=PT/L=Lisbon". The private key and public
# certificate are stored in files named with the given "${CA_PRIVATE_KEY}" and
# "${CA_CERTIFICATE}" variables.
function create_certificate_authority {
    openssl req -x509 -nodes -sha256 -days 356 -nodes -newkey rsa:2048 \
        -subj "/CN=msousa/C=PT/L=Lisbon" \
        -keyout ${CA_PRIVATE_KEY} -out ${CA_CERTIFICATE}
}

# Generates a 2048-bit RSA private key using OpenSSL and saves it to a file
# specified by the SERVER_PRIVATE_KEY variable.
function create_server_private_key {
    openssl genrsa -out ${SERVER_PRIVATE_KEY} 2048
}

# Creates a configuration file for the Certificate Signing Request (CSR) with
# subject DN fields, including domain name, country, city, organization, unit,
# and IP addresses, and subject alternate name.
function create_csr_config {
    echo \
"[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = PT
ST = Lisbon
L = Lisbon
O = 42 Lisboa
OU = Eternity
CN = ${DOMAIN}

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = ${DOMAIN}
DNS.2 = localhost
IP.1 = ${DOMAIN_IP}
IP.2 = 127.0.0.1
" \
    > ${CONFIG_SIGN_REQUEST}
}

# Generates a Certificate Signing Request (CSR) using the server's private key.
# It uses the openssl command to execute this, with the req subcommand. The
# input is the server's private key file and the output is the CSR file. The
# configuration for the CSR is specified in the CONFIG_SIGN_REQUEST file. The
# -nodes option is passed to not encrypt the private key.
function generate_csr_with_server_private_key {
    openssl req -new -key ${SERVER_PRIVATE_KEY} -out ${SERVER_SIGN_REQUEST} \
        -nodes -config ${CONFIG_SIGN_REQUEST}
}

# Create a text file in the format of an X.509 extension configuration file with
# the contents defining the subjectAltName and the purpose of the digital
# signature in the SSL certificate. It sets the file name to the value stored in
# the CONFIG_EXTENSION variable.
function create_extension_config {
    echo \
"authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${DOMAIN}
DNS.2 = localhost
" \
    > ${CONFIG_EXTENSION}
}

# Generates an SSL certificate using the Certificate Authority private key, the
# server's Certificate Signing Request (CSR) and a configuration file for request
# extensions. The command used is openssl x509 with the options -req to specify
# the CSR, -CA to specify the CA certificate, -CAkey to specify the CA private
# key, -CAcreateserial to create a new serial number for the certificate, -sha256
# to use SHA-256 hash function, -days 365 for the validity of the certificate,
# -out to specify the output certificate, and -extfile to specify the extension
# configuration file.
function generate_ssl_certificate_with_ca {
    openssl x509 -req -in ${SERVER_SIGN_REQUEST} -CA ${CA_CERTIFICATE} \
        -CAkey ${CA_PRIVATE_KEY} -CAcreateserial -sha256 -days 365 \
        -out ${SERVER_CERTIFICATE} -extfile ${CONFIG_EXTENSION}
}

echo ": 1. Create Certificate Authority"
create_certificate_authority

echo ": 2. Create the Server private key"
create_server_private_key

echo ": 3. Create Certificate Signing Request configuration"
create_csr_config

echo ": 4. Generate Certificate Signing Request (CSR) using Server private key"
generate_csr_with_server_private_key

echo ": 5. Create a configuration file containing certificate and request X.509 extensions to add."
create_extension_config

echo ": 6. Generate SSL certificate with self signed CA"
generate_ssl_certificate_with_ca

echo ": 7. Clean"
rm -f ${CONFIG_EXTENSION} ${CONFIG_SIGN_REQUEST} ${SERVER_SIGN_REQUEST}

