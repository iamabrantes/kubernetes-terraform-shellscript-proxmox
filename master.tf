# Proxmox Full-Clone
# ---
# Create a new VM from a clone

resource "proxmox_vm_qemu" "master" {
    
    # VM General Settings
    target_node = "proxmox"
    vmid = "300"
    name = "master"
    desc = "masterk8s"

    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = "ubuntu-2004-cloudinit-template"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 4
    sockets = 1
    cpu = "host"
    
    # VM Memory Settings
    memory = 4096
    
    # Disk Settings
    disk {
        size    = "30G"
        type    = "scsi"
        storage = "local-lvm"
    }

    # VM Network Settings
    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

    # (Optional) IP Address and Gateway
    ipconfig0 = "ip=192.168.1.210/24,gw=192.168.1.1"
    
    # (Optional) Default User
    # ciuser = "your-username"
    
    # (Optional) Add your SSH KEY
    sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDf9Y68pGLpkyJXfSwqYP5D3yLOMXN/LA1VJosmcnuNMQft2Y0vf7o4tzVmDg/lKRTIb/Ym+dYr4s6eyopWbr+miilBsda8u9NUP54/VXnUcvE30lE2/Em5UF9n1cwaF2w4npVLSA2IdCmLAOILiMWUlFRDurNx3Tp9Be3s8RoD2WndLmFlk9XcybEIUa2kf6LingW5S0Bnq7gOXdtkkRaWUOsrJhy5q79/2H44FUeqNKpdzBRef8953D7I1xGdzPp0VlG+tddVciJatHCp/W0cmBKZRA6eT20MoTJb9cVenS/lNy3Ci5UVvHHXGcbsL3C2aCxe1WJWPdBBWDWyGzwl root@proxmox
    EOF

    # Create connection to use provisioner file and exec
    connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = file("~/.ssh/id_rsa")
        host        = "192.168.1.210"
    }

    # Copy Scripts
    provisioner "file" {
        source = "scripts"
        destination = "/home/ubuntu/scripts"
    }

    # Execute Script
    provisioner "remote-exec" {
        inline = [
            "sudo chmod +x /home/ubuntu/scripts/*",
            "sudo /home/ubuntu/scripts/common.sh",
            "sudo /home/ubuntu/scripts/master.sh",
            "echo creating http to upload kubernetes join files",
            "cd /terraform/configs/",
            "nohup python3 -m http.server &",
            "sleep 1",
        ]
    }
}