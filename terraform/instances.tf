resource "digitalocean_droplet" "controller" {
	name = "controller-${count.index}"
  image = "ubuntu-16-04-x64"
  region = "lon1"
  size = "s-1vcpu-3gb"
  ssh_keys = [ "12701380" ]
	private_networking = true
	monitoring = true

	count = 3

}

resource "digitalocean_droplet" "worker" {
	name = "worker-${count.index}"
  image = "ubuntu-16-04-x64"
  region = "lon1"
  size = "s-1vcpu-3gb"
  ssh_keys = [ "12701380" ]
	private_networking = true
	monitoring = true

	count = 3

}
