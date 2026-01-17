packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

source "azure-arm" "nginx" {
  azure_tags = {
    dept = "Engineering"
    task = "Image deployment"
  }
  client_id                         = "54410766-b09f-4587-9a36-fb09fb19e271"
  client_secret                     = "xxxxxxxxxxxxxxxx"
  image_offer                       = "0001-com-ubuntu-server-jammy"
  image_publisher                   = "canonical"
  image_sku                         = "22_04-lts"
  location                          = "west us"
  managed_image_name                = "myPackerImage"
  managed_image_resource_group_name = "myresourceGroup"
  os_type                           = "Linux"
  subscription_id                   = "29a3f52d-be41-4c3d-9f54-e5e0210dfe4b"
  tenant_id                         = "db63169e-99bc-4546-a048-9d957b4c146a"
  vm_size                           = "Standard_D2s_v3"

}

build {
  sources = ["source.azure-arm.nginx"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["apt-get update", "apt-get upgrade -y", "apt-get -y install nginx","cd /tmp", "git clone https://github.com/devopsinsiders/StreamFlix.git","cp -r /tmp/StreamFlix/* /var/www/html", "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    inline_shebang  = "/bin/sh -x"
  }

}
