/* Setup terraform access to azure: https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure */
subscription_id = "YOUR_SUBSCRIPTION_ID_HERE"
client_id       = "YOUR_CLIENT/APPLICATION_ID_HERE"
client_secret   = "YOUR_KEY_HERE"
tenant_id       = "AZURE_TENANT_ID_HERE"

/* Declare default values will be used to deploy Threat Manager */
resource_group_name           = "myResourceGroup"
location                      = "location/region"
virtual_network_name          = "myvNet"
virtual_network_address_space = "192.168.0.0/16"
subnet_name                   = "mySubnet"
storage_account_name          = "myStorageAccount"
blob_container_name           = "myBlobContainer"
vm_name                       = "alertlogic-tm-vm"
vm_size                       = "Standard_A3"
