#!/bin/sh

location="westeurope"
echo -e "Deployment in $location location ...\n"

prefix="CUDA"
rg_ngf="$prefix-RG"

# Input password 
echo -n "Enter password: "
stty_orig=`stty -g` # save original terminal setting.
stty -echo          # turn-off echoing.
read passwd         # read the password
stty $stty_orig     # restore terminal setting.
                           
# Create resource group for NextGen Firewall resources
echo -e "\nCreating $rg_ngf resource group ...\n"
az group create --location "$location" --name "$rg_ngf"

# Deploy NextGen Firewall resources
echo -e "\nDeployment of $rg_ngf resources ...\n"
az group deployment create --verbose --resource-group "$rg_ngf" \
                           --template-file azuredeploy.json \
                           --parameters "@azuredeploy.parameters.json" \
                           --parameters adminPassword=$passwd prefix=$prefix
