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
EXTERNAL_IP=$(curl -X GET --silent "https://api.digitalocean.com/v2/droplets?per_page=999" -H "Authorization: Bearer $DO_API_TOKEN" | jq '.droplets[] | .networks.v4[] | select(.type == "public") .ip_address' | sed '1n' )
INTERNAL_IP=$(curl -X GET --silent "https://api.digitalocean.com/v2/droplets?per_page=999" -H "Authorization: Bearer $DO_API_TOKEN" | jq '.droplets[] | .networks.v4[] | select(.type == "private") .ip_address' | sed '1n' )

.droplets[] | select( .tags[] == "worker" ) | .networks.v4[] | select(.type == "private") .ip_address

for instance in worker-1 worker-2 worker-3; do

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${instance},${EXTERNAL_IP},${INTERNAL_IP} \
  -profile=kubernetes \
  ${instance}-csr.json | cfssljson -bare ${instance}
done
