# main.tf

# Define Terraform and the GCP provider
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Create a VPC network
resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc-network"
  auto_create_subnetworks = true
}

# Create a Cloud Storage bucket
resource "google_storage_bucket" "storage_bucket" {
  name     = "${var.project_id}-bucket"
  location = var.region
}

# Create a Compute Engine VM instance
resource "google_compute_instance" "vm_instance" {
  name         = "my-vm-instance"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-10"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {}
  }

  tags = ["http-server"]
}

# Firewall rule to allow HTTP traffic
resource "google_compute_firewall" "default" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["http-server"]
}

# Output instance IP address
output "vm_instance_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

output "bucket_name" {
  description = "Name of the storage bucket"
  value       = google_storage_bucket.storage_bucket.name
}
