#!/bin/bash
{
echo "Starting Barracuda CloudGen Firewall bootstrap script"
#echo "Setting DNS server ... "
#echo "nameserver 168.63.129.16" > /etc/resolv.conf
echo "Download PAR file ... "
curl https://raw.githubusercontent.com/jvhoof/ngf-azure-templates/master/Playground/resources/config-payg-ha.par --output /root/config-payg-ha.par
echo "Restore PAR file ... "
cp /root/config-payg-ha.par /opt/phion/update/box.par && \
    /etc/rc.d/init.d/phion stop && \
    /etc/rc.d/init.d/phion start && \
    /opb/cloud-setmip "$1" "$2" "$3"
#echo "Restoring PAYG license ... "
#/opb/cloud-restore-license -f
} > /tmp/provision-ha.log 2>&1