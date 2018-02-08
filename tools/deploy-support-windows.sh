#!/bin/bash
##############################################################################################################
#  ____                                      _       
# | __ )  __ _ _ __ _ __ __ _  ___ _   _  __| | __ _ 
# |  _ \ / _` | `__| `__/ _` |/ __| | | |/ _` |/ _` |
# | |_) | (_| | |  | | | (_| | (__| |_| | (_| | (_| |
# |____/ \__,_|_|  |_|  \__,_|\___|\__,_|\__,_|\__,_|
#                                                    
# Script to deploy the Windows servers into Microsoft Azure behind the Barracuda NextGen Firewall F. 
# This will install a Windows Server in red, green or both tiers of the quickstart deployment.
##############################################################################################################

$choice = "None"

echo "Do you wish to install a server in  in boththis program?"
select yn in "Red" "Green" "Both"; do
    case $yn in
        Red ) $choice = "Red"; break;;
        Green ) $choice = "Green"; break;;
        Both ) $choice = "Both"; break;;
    esac
done

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
    --name "$prefix-VM-WIN-NIC" \
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
    --name "$prefix-VM-WIN" \
    --location "$location" \
    --nics "$prefix-VM-WIN-NIC" \
    --image Win2016Datacenter \
    --admin-username azureuser \
    --authentication-type password \
    --admin-password "$passwd"
result=$? 
if [[ $result != 0 ]]; 
then 
    echo "--> Deployment failed ..."
    exit $rc; 
fi
