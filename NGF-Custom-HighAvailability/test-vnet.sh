#!/bin/sh

location="westeurope"
echo -e "Deployment in $location location ...\n"

prefix="CUDA"
rg_vnet="$prefix-RG-VNET"
vnet_name="$prefix-VNET"
vnet_ip="172.16.136.0/22"
subnet_ngf="$prefix-SUBNET-NGF"
subnet_ngf_ip="172.16.136.0/24"
ngf_ip="172.16.136.10"
ngf_dns="$prefix-ngf"
vm_size="Standard_DS1_v2"
image_sku="byol"

# Create resource group for NextGen Firewall resources
echo -e "\nCreating $rg_vnet resource group ...\n"
az group create --location "$location" --name "$rg_vnet"

# Deploy VNET
echo -e "\nDeployment of $rg_vnet resources ...\n"
az group deployment create --verbose --resource-group "$rg_vnet" \
                           --template-file test-vnet.json \
                           --parameters "{ 
                                            \"vNetName\": { \"value\": \"$vnet_name\" },
                                            \"vNetPrefix\": { \"value\": \"$vnet_ip\" },
                                            \"subnetNameNGF\": { \"value\": \"$subnet_ngf\" },
                                            \"subnetPrefixNGF\": { \"value\": \"$subnet_ngf_ip\" }
                                         }" 
