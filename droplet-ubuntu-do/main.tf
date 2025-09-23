data "digitalocean_ssh_key" "do_test_ssh_key" {
  name = var.ssh_key
}

data "digitalocean_domain" "do_test_domain" {
  name = var.domain_name
}

resource "digitalocean_droplet" "do_test_droplet" {
  image = "ubuntu-24-04-x64"
  name = var.droplet_name
  region = var.region
  size = "s-1vcpu-1gb"
  ssh_keys = [data.digitalocean_ssh_key.do_test_ssh_key.id]
}

resource "digitalocean_record" "do_test_record" {
  domain = data.digitalocean_domain.do_test_domain.id
  type = "A"
  name = var.record_name
  ttl = 3600
  value = digitalocean_droplet.do_test_droplet.ipv4_address
}

output "droplet_ssh_key" {
  value = data.digitalocean_ssh_key.do_test_ssh_key.name
}

output "droplet_public_ip" {
  value = digitalocean_droplet.do_test_droplet.ipv4_address
}

output "droplet_public_dns" {
  value = digitalocean_record.do_test_record.fqdn
}
