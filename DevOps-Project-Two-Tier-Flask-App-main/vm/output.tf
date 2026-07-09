output "public_ip" {
  description = "Public IP of the VM"
  value       = google_compute_instance.server.network_interface[0].access_config[0].nat_ip
}

output "ssh_command" {
  description = "Command to SSH into the VM"
  value       = "ssh -i /path/to/private_key ${var.ssh_user}@${google_compute_instance.server.network_interface[0].access_config[0].nat_ip}"
}
