/* Configure Azure Provider and declare all the Variables that will be used in Terraform configurations */
provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  version         = "~> 2.20.0"
  features {}
}

variable "subscription_id" {
  description = "Enter Subscription ID for provisioning resources in Azure"
}

variable "client_id" {
  description = "Enter Client ID for Application created in Azure AD"
}

variable "client_secret" {
  description = "Enter Client secret for Application in Azure AD"
}

variable "tenant_id" {
  description = "Enter Tenant ID / Directory ID of your Azure AD."
}

variable "resource_group_name" {
  description = "Name of the resource group in which to deploy your new Virtual Machines"
}

variable "location" {
  description = "The location/region where the virtual network resides."
}

variable "storage_account_name" {
  description = "Storage account name created for VM image deployment."
}

variable "blob_container_name" {
  description = "Blob container name created within storage account for VM image deployment (ex. vhds)."
}

variable "vm_name" {
  description = "Name your virtual TM machine."
}

variable "virtual_network_name" {
  description = "Name of an existing Virtual Network where Threat Manager will be deployed in."
}

variable "virtual_network_address_space" {
  description = "Address space in CIDR notation of the existing virtual network where agents will be deployed."
}

variable "subnet_name" {
  description = "Name of the desired subnet. Must exist in your chosen Virtual Network."
}

variable "vm_size" {
  description = "Select the size of your Threat Manager virtual machine. Allowed values: Standard_A3, Standard_A4."
  type        = string
  default     = "Standard_A3"
}

variable "os_type" {
  description = "Type of OS on the existing vhd. Allowed values: 'linux'."
  default     = "linux"
}

variable "admin_username" {
  description = "Name of the local administrator account. Do not change the default value. Alert Logic don't use these credentials, is only required by Azure when creating new VM."
  default     = "alertlogic"
}

variable "admin_password" {
  description = "Local administrator password. Do not change the default value. Alert Logic don't use these credentials, is only required by Azure when creating new VM."
  default     = "P@ssw0rd12345"
}

variable "alertlogicIPRange1" {
  description = "Alert Logic source/destination CIDR range 1."
  default     = "204.110.218.96/27"
}

variable "alertlogicIPRange2" {
  description = "Alert Logic source/destination CIDR range 2."
  default     = "204.110.219.96/27"
}

variable "alertlogicIPRange3" {
  description = "Alert Logic source/destination CIDR range 3."
  default     = "208.71.209.32/27"
}

variable "alertlogicIPRange4" {
  description = "Alert Logic source/destination CIDR range 4."
  default     = "185.54.124.0/24"
}
