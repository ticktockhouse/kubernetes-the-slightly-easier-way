#!/bin/bash

for instance in worker-1 worker-2 worker-3; do
  EXTERNAL_IP=$(/snap/bin/doctl compute droplet list $instance  | sed '1d' | awk '{print $3}' )
  INTERNAL_IP=$(/snap/bin/doctl compute droplet list $instance  | sed '1d' | awk '{print $4}' )

  cfssl gencert \
    -ca=./certs/ca.pem \
    -ca-key=./certs/ca-key.pem \
    -config=ca-config.json \
    -hostname=${instance},${EXTERNAL_IP},${INTERNAL_IP} \
    -profile=kubernetes \
    ${instance}-csr.json | cfssljson -bare ${instance}
done

mv worker-*.pem worker-*.csr ./certs
