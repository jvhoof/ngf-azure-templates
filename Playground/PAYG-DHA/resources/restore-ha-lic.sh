#!/bin/bash
echo "
##############################################################################################################
#  _                         
# |_) _  __ __ _  _     _| _ 
# |_)(_| |  | (_|(_ |_|(_|(_|
#
# Restore the PAYG license from the seconday unit and add them to the cluster.
#
##############################################################################################################

Copy license from secondary unit

"
haip=`python2.7 /root/get-ha-ip.py`
scp root@$haip:/var/phion/preserve/cloud/license/boxlic.conf .
echo "\nAdd license into configuration\n"
sed -e '1,2d' < boxlic.conf >> /opt/phion/config/configroot/boxother/boxlic.conf 
echo "\nActivate changes\n"
cd /opt/phion/modules/box/boxother/boxlic/bin
./activate

echo "
##############################################################################################################
#  _                         
# |_) _  __ __ _  _     _| _ 
# |_)(_| |  | (_|(_ |_|(_|(_|
#
# License added into the primary unit configuration. 
# Sync the config and activate the box config on the secondary unit.
#
# Connect via email:
# azure_support@barracuda.com
#
##############################################################################################################
"