# DL CFSSL :)
wget -q --show-progress --https-only --timestamping \
  https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
  https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64

sudo cp cfssl_linux-amd64 /usr/local/bin/cfssl
sudo cp cfssljson_linux-amd64 /usr/local/bin/cfssljson

sudo chmod +x /usr/local/bin/cfssl
sudo chmod +x /usr/local/bin/cfssljson

# DL kubectl

wget https://storage.googleapis.com/kubernetes-release/release/v1.9.0/bin/linux/amd64/kubectl

sudo cp kubectl /usr/local/bin/kubectl
sudo chmod +x /usr/local/bin/kubectl
