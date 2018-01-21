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
