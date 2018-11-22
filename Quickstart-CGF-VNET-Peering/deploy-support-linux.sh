#!/bin/bash
echo "
##############################################################################################################
#  _                         
# |_) _  __ __ _  _     _| _ 
# |_)(_| |  | (_|(_ |_|(_|(_|
#
# Script to deploy Linux servers into Microsoft Azure behind the Barracuda CloudGen Firewall. 
# This will install a Linux Server in red, green, spoke1 and spoke2 of the quickstart deployment.
#
##############################################################################################################

"

# Stop on error
set +e

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
rg="$prefix-RG"

for TIER in RED GREEN SPOKE1 SPOKE2
do
    echo "--> Deployment $TIER NIC ..."
    az vm nic show --resource-group "$rg" --nic "$prefix-VM-$TIER-NIC" --vm-name "$prefix-VM-$TIER"  &> /dev/null
    if [[ $? != 0 ]]; 
    then 
        vnet="$prefix-VNET"
        if [[ "$TIER" == "SPOKE1" || "$TIER" == "SPOKE2" ]]
        then
            vnet="$prefix-VNET-$TIER"
        fi
        az network nic create \
            --resource-group "$rg" \
            --name "$prefix-VM-$TIER-NIC" \
            --vnet-name "$vnet" \
            --subnet "$prefix-SUBNET-$TIER"
        result=$? 
        if [[ $result != 0 ]]; 
        then 
            echo "--> Deployment $TIER NIC failed ..."
            exit $rc; 
        fi
    else
            echo "--> Deployment $TIER NIC found ..."
    fi

    echo "--> Deployment $TIER VM ..."
    az vm show -g "$rg" -n "$prefix-VM-$TIER" &> /dev/null
    if [[ $? != 0 ]]; 
    then 
        az vm create \
            --resource-group "$rg" \
            --name "$prefix-VM-$TIER" \
            --nics "$prefix-VM-$TIER-NIC" \
            --image UbuntuLTS \
            --generate-ssh-keys \
            --output json 
        result=$? 
        if [[ $result != 0 ]]; 
        then 
            echo "--> Deployment $TIER VM failed ..."
            exit $rc; 
        fi
    else
            echo "--> Deployment $TIER VM found ..."
    fi
done
