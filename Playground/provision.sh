#!/bin/bash
{
echo "Starting Barracuda CloudGen Firewall bootstrap script"
echo "Setting DNS server ... "
echo "nameserver 168.63.129.16" > /etc/resolv.conf
echo "Download PAR file ... "
curl https://raw.githubusercontent.com/jvhoof/quickstart-blue-green-azure/master/resources/quickstart-blue.par --output /root/quickstart-blue.par
echo "Restore PAR file ... "
cp /root/quickstart-blue.par /opt/phion/update/box.par && \
    /etc/rc.d/init.d/phion stop && \
    /etc/rc.d/init.d/phion start && \
    /opb/cloud-setmip 172.16.136.4 24 172.16.136.1 
echo "Restoring PAYG license ... "
/opb/cloud-restore-license -f
echo "Creating CGF cluster ... "
echo 'Q1w2e34567890--' | /opb/create-dha -s S1 -c -o '172.16.136.6' -n '24' -g '172.16.136.1'
} > /tmp/provision.log 2>&1

#    "ngfCustomData1": "[base64(concat('#!/bin/bash\n\n', '{ echo \"Starting Barracuda CloudGen Firewall bootstrap.\"\necho \"nameserver 168.63.129.16\" > /etc/resolv.conf\ncurl \"https://raw.githubusercontent.com/jvhoof/quickstart-blue-green-azure/master/resources/quickstart-blue.par\" --output /root/backupdeployment.par\ncp /root/backupdeployment.par /opt/phion/update/box.par && /etc/rc.d/init.d/phion stop && /etc/rc.d/init.d/phion start && /opb/cloud-setmip', variables('ngfVmAddress1'), variables( 'ngfSubnetMask' ), variables( 'ngfSubnetDefaultGw' ), '\n/opb/cloud-restore-license -f\n} > /tmp/provision.log\n'))]",
#    "ngfCustomData1": "[base64(concat('#!/bin/bash\n\n echo \"nameserver 168.63.129.16\" > /etc/resolv.conf\ncurl \"https://raw.githubusercontent.com/jvhoof/ngf-azure-templates/master/Playground/provision.sh\" --output /tmp/provision.sh\n bash /tmp/provision.sh'))]",