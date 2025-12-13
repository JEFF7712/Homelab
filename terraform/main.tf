resource "proxmox_lxc" "container" {
  target_node  = "pve"
  hostname     = "lxc-netbird"
  ostemplate   = "local:vztmpl/ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst"
  password     = "7712"
  unprivileged = true
  start        = true

  cores   = 1
  memory  = 512
  swap    = 512

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "10.1.34.135/24"
    gw     = "10.1.34.1"
  }

  ssh_public_keys = var.ssh_public_key
}

  resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tftpl", {
    # vm_ips = proxmox_vm_qemu.node[*].default_ipv4_address
    # grabs the first interface's IP and strips the subnet mask
    lxc_ips = [
      for lxc in proxmox_lxc.container : 
      replace(lxc.network[0].ip, "/\\/[0-9]+$/", "")
    ]
  })
  
  filename = "../ansible/inventory/generated_hosts.ini"
}
