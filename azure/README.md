Azure Terraform Template for AlertLogic Threat Manager
=========================================================
Use this template to deploy Alert Logic Threat Manager into your existing Azure IaaS infrastructure.

Requirements
------------
* Copy the Threat Manager from Alert Logic managed storage account
* Valid Azure subscription with virtual network and subnet created
* New or existing storage account and blob container within your resource group
* Alert Logic account with an active Threat Manager subscription

Sample usage
------------
1. First you must copy the Alert Logic Threat Manager vhd image to a new or existing [Azure Storage Account](https://azure.microsoft.com/en-us/documentation/articles/storage-create-storage-account/#create-a-storage-account) within the same resource group using [Azure CLI](https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-install/) before running terraform

 > View and copy [Azure Storage Access Key](https://azure.microsoft.com/en-us/documentation/articles/storage-create-storage-account/#manage-your-storage-access-keys):
 >
 > In the Azure Portal, navigate to your storage account and click the Keys icon to view, copy, and regenerate your account access keys. The Access Keys blade also includes pre-configured connection strings using your primary and secondary keys that you can copy to use in your applications

    azure config mode asm
    azure vm disk upload http://alertlogic.blob.core.windows.net/tmcimage/al-tmc-image_latest.vhd [storage account URL]/[blob container name]/al-tmc-image_latest.vhd [storage-account-key]

2. Setup your Azure Deployment in the Alert Logic console for automatic appliance claim and metadata extraction (Recommended). See https://docs.alertlogic.com/userGuides/deployments.htm#settingsAzure

3. Add the required variables to var_values.tfvars file and match it to your Azure subscription including provider access, plan and then apply the Terraform template

4. (Optional for manual claim) Grab the public / external IP from the Terraform output or directly from the Azure portal

5. (Optional for manual claim) Open http://external-ip

6. (Optional for manual claim) Enter your unique registration key associated with your Alert Logic account to claim the appliance manually


Variables
----------
  * resource_group_name : Name of an existing resource group containing your virtual network
  * location : The Azure Region to provision the new Threat Manager VM in, i.e. West US
  * virtual_network_name : The name of a virtual network to deploy the Threat Manager VM in
  * virtual_network_address_space : CIDR notation of the existing virtual network where agents will be deployed in
  * availability_set_name : The name of the Availability Set in which to create the Threat Manager VM in
  * subnet_name : The name of an existing subnet within your selected virtual network
  * storage_account_name : Name of an existing storage account where the Threat Manager vhd image was copied to
  * blob_container_name : The container name where the Threat Manager vhd image was copied to
  * vm_name : Name of the new Threat Manager VM being deployed
  * vm_size : Size of the new Threat Manager VM being deployed (Defaults to Standard_A3)

Additional information
----------------------

#### Reference

[Alert Logic Threat Manager for Azure IaaS Online Docs](https://docs.alertlogic.com/cloud/microsoft-azure-threat-manager-iaas-marketplace.htm)
