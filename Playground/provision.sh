#!/bin/bash
{
echo "Starting Barracuda CloudGen Firewall bootstrap script"
echo "nameserver 168.63.129.16" > /etc/resolv.conf
curl https://raw.githubusercontent.com/jvhoof/quickstart-blue-green-azure/master/resources/quickstart-$COLOR.par --output /root/quickstart-$COLOR.par
cp /root/quickstart-$COLOR.par /opt/phion/update/box.par && /etc/rc.d/init.d/phion stop && /etc/rc.d/init.d/phion start
/opb/cloud-setmip $CGFIP $CGFSM $CGFGW
/opb/cloud-restore-license -f
} > /tmp/provision.log 2>&1

"ngfCustomData1": "[base64(concat('#!/bin/bash\n\n echo \"nameserver 168.63.129.16\" > /etc/resolv.conf\ncurl \"https://raw.githubusercontent.com/jvhoof/ngf-azure-templates/master/Playground/provision.sh\" --output /tmp/provision.sh\n bash /tmp/provision.sh')]",