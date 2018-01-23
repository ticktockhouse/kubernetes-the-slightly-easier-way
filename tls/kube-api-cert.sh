#!/bin/bash

WORKER_PRIVATE_IP_LIST=$(/snap/bin/doctl compute droplet list | grep worker | awk '{print $4}')
CONTROLLER_PRIVATE_IP_LIST=$(/snap/bin/doctl compute droplet list | grep worker | awk '{print $4}')
WORKER_PRIVATE_CS=$(echo $WORKER_PRIVATE_IP_LIST | tr ' ' ',')
CONTROLLER_PRIVATE_CS=$(echo $CONTROLLER_PRIVATE_IP_LIST | tr ' ' ',')
KUBERNETES_PUBLIC_ADDRESS=$(/snap/bin/doctl compute load-balancer list | awk '{print $2}' | sed 1d)


cfssl gencert \
  -ca=certs/ca.pem \
  -ca-key=certs/ca-key.pem \
  -config=ca-config.json \
  -hostname=${WORKER_PRIVATE_CS},${CONTROLLER_PRIVATE_CS},${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,kubernetes.default \
  -profile=kubernetes \
  kubernetes-api-csr.json | cfssljson -bare kubernetes

mv *.csr *.pem ./certs
