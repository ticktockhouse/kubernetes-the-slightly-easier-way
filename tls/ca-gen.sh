#!/bin/bash

# Make certs directory
mkdir ./certs
# Generate the CA key and cert
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
# Generate key from CA bits
cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  admin-csr.json | cfssljson -bare admin
# Move the generated stuff to the certs directory
mv ca.pem ca-key.pem ca.csr admin.pem admin-key.pem admin.csr ./certs
# Generate worker certs

for instance in worker-1 worker-2 worker-3; do
  EXTERNAL_IP=$(/snap/bin/doctl compute droplet list $instance  | sed '1d' | awk '{print $3}' )
  INTERNAL_IP=$(/snap/bin/doctl compute droplet list $instance  | sed '1d' | awk '{print $4}' )

  cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=ca-config.json \
    -hostname=${instance},${EXTERNAL_IP},${INTERNAL_IP} \
    -profile=kubernetes \
    ${instance}-csr.json | cfssljson -bare ${instance}
done
