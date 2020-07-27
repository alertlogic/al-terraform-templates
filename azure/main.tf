/*
TerraForm Template for Alert Logic Threat Manager Appliance deployment in Azure

You must copy the Alert Logic Threat Manager vhd image to a new or existing storage account within the same resource group before running terraform.

 1) View and copy storage access keys:
 In the Azure Portal, navigate to your storage account and click the Keys icon to view, copy, and regenerate your account access keys. The Access Keys blade also includes pre-configured connection strings using your primary and secondary keys that you can copy to use in your applications.

 2) Open a terminal or command prompt and set azure cli mode to asm:
    $ azure config mode asm

 3) Copy the Threat Manager vhd to your storage account
    $ azure vm disk upload http://alertlogic.blob.core.windows.net/tmcimage/al-tmc-image_latest.vhd [storage account URL]/[blob container name]/al-tmc-image_latest.vhd [storage-account-key]

 Usage:
 1. copy this template to your working directory, i.e. ~/azure-tmc
 2. add all the required variables in separate file, i.e. var_values.tfvars
 3. run TerraForm plan first then apply
    $ terraform apply -var-file var_values.tfvars

 +++Provider configuration+++
 Terraform supports authenticating to Azure through a Service Principal or the Azure CLI.
 Terraform recommend using a Service Principal when running in a Shared Environment (such as within a CI server/automation) - and authenticating via the Azure CLI when you're running Terraform locally.

 Specify the provider access details and assign default values for the variables will be used by the main template in variables.tf
 */

resource "azurerm_public_ip" "tm_vm_pip" {
  name                = "${var.vm_name}-PIP"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "tm_vm_nsg" {
  name                = "${var.vm_name}-NSG"
  resource_group_name = var.resource_group_name
  location            = var.location

  security_rule {
    name                       = "allow_agent_network_transport"
    description                = "Agent data transport (between agent and appliance on local network)"
    priority                   = 2000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "7777"
    source_address_prefix      = var.virtual_network_address_space
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_single_point_of_egress"
    description                = "Agent HTTPs communication (between agent and appliance on local network)"
    priority                   = 2010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = var.virtual_network_address_space
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "update-rule-1"
    description                = "Allow HTTPs for updates"
    priority                   = 2100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = var.alertlogicIPRange1
  }

  security_rule {
    name                       = "update-rule-2"
    description                = "Allow HTTPs for updates"
    priority                   = 2200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = var.alertlogicIPRange2
  }

  security_rule {
    name                       = "update-rule-3"
    description                = "Allow HTTPs for updates"
    priority                   = 2300
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = var.alertlogicIPRange3
  }

  security_rule {
    name                       = "update-rule-4"
    description                = "Allow HTTPs for updates"
    priority                   = 2310
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = var.alertlogicIPRange4
  }

  security_rule {
    name                       = "event-transport-rule-1"
    description                = "Allow Event Transport to AlertLogic"
    priority                   = 2400
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "4138"
    source_address_prefix      = "*"
    destination_address_prefix = var.alertlogicIPRange1
  }

  security_rule {
    name                       = "event-transport-rule-2"
    description                = "Allow Event Transport to AlertLogic"
    priority                   = 2500
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "4138"
    source_address_prefix      = "*"
    destination_address_prefix = var.alertlogicIPRange2
  }

  security_rule {
    name                       = "event-transport-rule-3"
    description                = "Allow Event Transport to AlertLogic"
    priority                   = 2600
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "4138"
    source_address_prefix      = "*"
    destination_address_prefix = var.alertlogicIPRange3
  }

  security_rule {
    name                       = "event-transport-rule-4"
    description                = "Allow Event Transport to AlertLogic"
    priority                   = 2610
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "4138"
    source_address_prefix      = "*"
    destination_address_prefix = var.alertlogicIPRange4
  }

  security_rule {
    name                       = "dns-rule-1"
    description                = "Allow DNS"
    priority                   = 2700
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "*"
    destination_address_prefix = "8.8.4.4/32"
  }

  security_rule {
    name                       = "dns-rule-2"
    description                = "Allow DNS"
    priority                   = 2800
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "*"
    destination_address_prefix = "8.8.8.8/32"
  }

  security_rule {
    name                       = "ntp-rule-1"
    description                = "Allow NTP,time sync with AlertLogic"
    priority                   = 2900
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "123"
    source_address_prefix      = "*"
    destination_address_prefix = var.alertlogicIPRange2
  }

  security_rule {
    name                       = "ntp-rule-2"
    description                = "Allow NTP,time sync with AlertLogic"
    priority                   = 3000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "123"
    source_address_prefix      = "*"
    destination_address_prefix = var.alertlogicIPRange3
  }
}

resource "azurerm_availability_set" "tm_availability_set" {
  name                = "${var.vm_name}-AvailabilitySet1"
  location            = var.location
  resource_group_name = var.resource_group_name
  managed             = true
}

resource "azurerm_network_interface" "tm_vm_ni" {
  name                = "${var.vm_name}-VirtNic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.vm_name}-ipconfig"
    subnet_id                     = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.virtual_network_name}/subnets/${var.subnet_name}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tm_vm_pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "tm_ni_sg_association" {
  network_interface_id      = azurerm_network_interface.tm_vm_ni.id
  network_security_group_id = azurerm_network_security_group.tm_vm_nsg.id
}

resource "azurerm_image" "tm_vm_image" {
  name                = "${var.vm_name}-image"
  location            = var.location
  resource_group_name = var.resource_group_name

  os_disk {
    os_type  = var.os_type
    os_state = "Generalized"
    blob_uri = "http://${var.storage_account_name}.blob.core.windows.net/${var.blob_container_name}/al-tmc-image_latest.vhd"
    size_gb  = 100
  }
}

resource "azurerm_virtual_machine" "tm_vm" {
  name                          = var.vm_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  vm_size                       = var.vm_size
  network_interface_ids         = [azurerm_network_interface.tm_vm_ni.id]
  availability_set_id           = azurerm_availability_set.tm_availability_set.id
  delete_os_disk_on_termination = true

  storage_image_reference {
    id = azurerm_image.tm_vm_image.id
  }

  storage_os_disk {
    name              = "${var.vm_name}osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
