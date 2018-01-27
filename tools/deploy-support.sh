#!/bin/bash


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

az network nic create \
    --resource-group $rg_ngf \
    --name "$prefix-VM-LNX-NIC" \
    --vnet-name "$prefix-VNET" \
    --subnet "$prefix-SUBNET-RED"
result=$? 
if [[ $result != 0 ]]; 
then 
    echo "--> Deployment failed ..."
    exit $rc; 
fi

az vm create \
    --resource-group "$rg_ngf" \
    --name "$prefix-VM-LNX" \
    --location "$location" \
    --nics "$prefix-VM-LNX-NIC" \
    --image UbuntuLTS \
    --admin-username azureuser \
    --authentication-type password \
    --admin-password "$passwd"
result=$? 
if [[ $result != 0 ]]; 
then 
    echo "--> Deployment failed ..."
    exit $rc; 
fi
