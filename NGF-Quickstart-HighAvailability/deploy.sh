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

# Input location 
echo -n "Enter location (e.g. westeurope): "
stty_orig=`stty -g` # save original terminal setting.
read location         # read the password
stty $stty_orig     # restore terminal setting.
if [ -z "$location" ] 
then
    location="westeurope"
fi
echo "Deployment in $location location ...\n"

# Input prefix 
echo -n "Enter prefix: "
stty_orig=`stty -g` # save original terminal setting.
read prefix         # read the prefix
stty $stty_orig     # restore terminal setting.
if [ -z "$prefix" ] 
then
    prefix="CUDA"
fi
echo "Using prefix #prefix for all resources ...\n"
rg_ngf="$prefix-RG"

# Input password 
echo -n "Enter password: "
stty_orig=`stty -g` # save original terminal setting.
stty -echo          # turn-off echoing.
read passwd         # read the password
stty $stty_orig     # restore terminal setting.
                           
# Create resource group for NextGen Firewall resources
echo "\nCreating $rg_ngf resource group ...\n"
az group create --location "$location" --name "$rg_ngf"

# Validate template
echo -e "\nValidation deployment in $rg_ngf resource group ...\n"
az group deployment validate --verbose --resource-group "$rg_ngf" \
                           --template-file azuredeploy.json \
                           --parameters "@azuredeploy.parameters.json" \
                           --parameters adminPassword=$passwd prefix=$prefix
result=$? 
if [ $result != 0 ]; 
then 
    echo -e "\nValidation failed ...\n"
    exit $rc; 
fi

# Deploy NextGen Firewall resources
echo -e "\nDeployment of $rg_ngf resources ...\n"
az group deployment create --resource-group "$rg_ngf" \
                           --template-file azuredeploy.json \
                           --parameters "@azuredeploy.parameters.json" \
                           --parameters adminPassword=$passwd prefix=$prefix
result=$? 
if [[ $result != 0 ]]; 
then 
    echo -e "\nDeployment failed ...\n"
    exit $rc; 
fi