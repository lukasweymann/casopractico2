resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/../ansible/inventory.tmpl", {
    ip       = azurerm_public_ip.public_ip.ip_address
    vm_user  = var.admin_username
    key_path = pathexpand("~/.ssh/azure_vm_key")
  })

  filename = "${path.module}/../ansible/inventory.ini"
}