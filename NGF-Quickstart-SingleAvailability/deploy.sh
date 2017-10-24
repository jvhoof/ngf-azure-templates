#!/bin/sh
cat << "EOF"
##############################################################################################################
#  ____                                      _       
# | __ )  __ _ _ __ _ __ __ _  ___ _   _  __| | __ _ 
# |  _ \ / _` | `__| `__/ _` |/ __| | | |/ _` |/ _` |
# | |_) | (_| | |  | | | (_| | (__| |_| | (_| | (_| |
# |____/ \__,_|_|  |_|  \__,_|\___|\__,_|\__,_|\__,_|
#                                                    
# Script to deploy the Barracuda Next Gen Firewall F into Microsoft Azure. This script also creates the
# network infrastructure needed for it.
#
##############################################################################################################
EOF

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
az group deployment create --resource-group "$rg_ngf" \
                           --template-file azuredeploy.json \
                           --parameters "@azuredeploy.parameters.json" \
                           --parameters adminPassword=$passwd prefix=$prefix
