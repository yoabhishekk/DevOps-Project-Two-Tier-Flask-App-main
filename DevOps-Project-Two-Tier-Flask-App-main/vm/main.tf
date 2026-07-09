terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Ubuntu 22.04 LTS image
data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}

# Single firewall rule allowing the required ports
resource "google_compute_firewall" "allow_flask_jenkins" {
  name    = "allow-flask-jenkins"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "5000", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]   # ⚠️ Restrict to your IP for production
  target_tags   = ["flask-jenkins"]
}

# VM instance
resource "google_compute_instance" "server" {
  name         = "flask-jenkins-server"
  machine_type = "e2-micro"
  tags         = ["flask-jenkins"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
      size  = 20   # GB
    }
  }

  network_interface {
    network = "default"
    access_config {
      # Ephemeral public IP
    }
  }

  # Inject SSH key – replace with your own public key
  metadata = {
    ssh-keys = "${var.ssh_user}:${file(pathexpand(var.ssh_public_key_path))}"
  }
}
