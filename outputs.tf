
# outputs.tf

output "vpc_network_name" {
  description = "VPC Network name"
  value       = google_compute_network.vpc_network.name
}

output "vm_instance_ip" {
  description = "VM public IP"
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

output "storage_bucket_name" {
  description = "Cloud Storage bucket name"
  value       = google_storage_bucket.storage_bucket.name
}
