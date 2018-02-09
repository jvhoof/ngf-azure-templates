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

# Stop on error
set +e

if [ -z "$DEPLOY_TIERS" ]
then
    echo -n "Do you wish to install a server in Red, Greeen or Both tiers? "
    select yn in "Red" "Green" "Both"; do
        case $yn in
            Red ) $tiers = "Red"; break;;
            Green ) $tiers = "Green"; break;;
            Both ) $tiers = "Both"; break;;
        esac
    done
else
    location="$DEPLOY_TIERS"
fi
echo ""
echo "--> Deployment in $tiers tier(s) ..."
echo ""

if [ -z "$DEPLOY_LOCATION" ]
then
    # Input location 
    echo -n "Enter location (e.g. eastus2): "
    stty_orig=`stty -g` # save original terminal setting.
    read location         # read the location
    stty $stty_orig     # restore terminal setting.
    if [ -z "$location" ] 
    then
        location="eastus2"
    fi
else
    location="$DEPLOY_LOCATION"
fi
echo ""
echo "--> Deployment in $location location ..."
echo ""

if [ -z "$DEPLOY_PREFIX" ]
then
    # Input prefix 
    echo -n "Enter prefix: "
    stty_orig=`stty -g` # save original terminal setting.
    read prefix         # read the prefix
    stty $stty_orig     # restore terminal setting.
    if [ -z "$prefix" ] 
    then
        prefix="CUDA"
    fi
else
    prefix="$DEPLOY_PREFIX"
fi
echo ""
echo "--> Using prefix $prefix for all resources ..."
echo ""
rg_ngf="$prefix-RG"

if [ -z "$DEPLOY_PASSWORD" ]
then
    # Input password 
    echo -n "Enter password: "
    stty_orig=`stty -g` # save original terminal setting.
    stty -echo          # turn-off echoing.
    read passwd         # read the password
    stty $stty_orig     # restore terminal setting.
else
    passwd="$DEPLOY_PASSWORD"
    echo ""
    echo "--> Using password found in env variable DEPLOY_PASSWORD ..."
    echo ""
fi

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

if [ "$tiers" == "Red" || "$tiers" == "Both" ]
then
    az network nic create \
        --resource-group $rg_ngf \
        --name "$prefix-VM-RED-NIC" \
        --vnet-name "$prefix-VNET" \
        --subnet "$prefix-SUBNET-RED"
    result=$? 
    if [[ $result != 0 ]]; 
    then 
        echo "--> Deployment RED NIC failed ..."
        exit $rc; 
    fi

    az vm create \
        --resource-group "$rg_ngf" \
        --name "$prefix-VM-RED" \
        --location "$location" \
        --nics "$prefix-VM-RED-NIC" \
        --image Win2016Datacenter \
        --admin-username azureuser \
        --authentication-type password \
        --admin-password "$passwd"
    result=$? 
    if [[ $result != 0 ]]; 
    then 
        echo "--> Deployment RED VM failed ..."
        exit $rc; 
    fi
fi

if [ "$tiers" == "Green" || "$tiers" == "Both" ]
then
    az network nic create \
        --resource-group $rg_ngf \
        --name "$prefix-VM-GREEN-NIC" \
        --vnet-name "$prefix-VNET" \
        --subnet "$prefix-SUBNET-GREEN"
    result=$? 
    if [[ $result != 0 ]]; 
    then 
        echo "--> Deployment RED NIC failed ..."
        exit $rc; 
    fi

    az vm create \
        --resource-group "$rg_ngf" \
        --name "$prefix-VM-GREEN" \
        --location "$location" \
        --nics "$prefix-VM-GREEN-NIC" \
        --image UbuntuLTS \
        --admin-username azureuser \
        --authentication-type password \
        --admin-password "$passwd"
    result=$? 
    if [[ $result != 0 ]]; 
    then 
        echo "--> Deployment RED VM failed ..."
        exit $rc; 
    fi
fi
