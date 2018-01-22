#!/bin/bash
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

# Stop on error
set +e

# Input location 
echo -n "Enter location (e.g. eastus2): "
stty_orig=`stty -g` # save original terminal setting.
read location         # read the location
stty $stty_orig     # restore terminal setting.
if [ -z "$location" ] 
then
    location="eastus2"
fi
echo ""
echo "--> Deployment in $location location ..."
echo ""

# Input prefix 
echo -n "Enter prefix: "
stty_orig=`stty -g` # save original terminal setting.
read prefix         # read the prefix
stty $stty_orig     # restore terminal setting.
if [ -z "$prefix" ] 
then
    prefix="CUDA"
fi
echo ""
echo "--> Using prefix $prefix for all resources ..."
echo ""
rg_ngf="$prefix-RG"

# Input password 
echo -n "Enter password: "
stty_orig=`stty -g` # save original terminal setting.
stty -echo          # turn-off echoing.
read passwd         # read the password
stty $stty_orig     # restore terminal setting.

# Create resource group for NextGen Firewall resources
echo ""
echo "--> Creating $rg_ngf resource group ..."
az group create --location "$location" --name "$rg_ngf"

# Validate template
echo "--> Validation deployment in $rg_ngf resource group ..."
az group deployment validate --resource-group "$rg_ngf" \
                           --template-file azuredeploy.json \
                           --parameters "@azuredeploy.parameters.json" \
                           --parameters adminPassword=$passwd prefix=$prefix
result=$? 
if [ $result != 0 ]; 
then 
    echo "--> Validation failed ..."
    exit $rc; 
fi

# Deploy NextGen Firewall resources
echo "--> Deployment of $rg_ngf resources ..."
az group deployment create --resource-group "$rg_ngf" \
                           --template-file azuredeploy.json \
                           --parameters "@azuredeploy.parameters.json" \
                           --parameters adminPassword=$passwd prefix=$prefix
result=$? 
if [[ $result != 0 ]]; 
then 
    echo "--> Deployment failed ..."
    exit $rc; 
fi
