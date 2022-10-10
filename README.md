# terraform-shellscript-proxmox
Using terraform and shellscript to provision a VM on proxmox and create a Kubernetes cluster with 4 nodes and 1 jenkins VM

Steps:

1-Configure the API Token to connect with terraform on Proxmox.

2-Create a ubuntu template with ID 9000 for be cloned to the new machines.

3-Create a file named "credentials.auto.tfvars" with 3 variables.

proxmox_api_url = "https://x.x.x.x:8006/api2/json"  # Your Proxmox IP Address
proxmox_api_token_id = "x@x!x"  # API Token ID
proxmox_api_token_secret = "xxxxxx"

4-Run "terraform apply -auto-approve
