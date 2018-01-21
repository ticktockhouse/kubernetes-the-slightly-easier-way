resource digitalocean_loadbalancer "k8s-ell-bee" {
	name = "lb-1"
	region = "lon1"
  forwarding_rule {
    entry_port = 80
    entry_protocol = "http"

    target_port = 80
    target_protocol = "http"
	}
	droplet_ids = ["${digitalocean_droplet.controller.*.id}"]
}
