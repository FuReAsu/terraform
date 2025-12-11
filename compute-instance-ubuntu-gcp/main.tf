resource "google_compute_instance" "compute-instance" {

  name = var.instance_name
  machine_type = "e2-small"

  network_interface {
    network = "default"
    access_config {
    }
  }

  can_ip_forward = true

  boot_disk {
    initialize_params { 
      image = "ubuntu-minimal-2404-noble-amd64-v20251210"
    }
  }
  tags = [
    var.instance_name
  ]
  allow_stopping_for_update = true
}

resource "google_compute_firewall" "allow-https" {
  name = "allow-http-https-${var.instance_name}"
  network = "default"
  description = "allow https port 443 and http port 80 from anywhere"
  direction = "INGRESS"
  priority = 100

  source_ranges = ["0.0.0.0/0"]

  target_tags = [
    var.instance_name
  ]

  allow {
    protocol = "tcp"
    ports = ["443","80"]
  }
}

output "instance-public-ip" {
  value = google_compute_instance.compute-instance.network_interface[0].access_config[0].nat_ip
}
