# Barracuda CloudGen Firewall for Azure - Pay As You Go High Availability Cluster in an Availability Set using an Internal Standard Load Balancer

## Introduction

This ARM Template is a variation of the [NGF-Quickstart-HA-1NIC-AS-ELB-ILB-STD](https://github.com/jvhoof/ngf-azure-templates/tree/master/NGF-Quickstart-HA-1NIC-AS-ELB-ILB-STD) template. In this template the use of PAYG is enforced and a backup of the configuration is retrieved from GitHub.

![Network diagram](images/cgf-ha-1nic-elb-ilb.png)

## Prerequisites

Verify the prerequisites [here](https://github.com/jvhoof/ngf-azure-templates/tree/master/NGF-Quickstart-HA-1NIC-AS-ELB-ILB-STD#prerequisites)

This ARM Template is only for standalone HA clusters. Using a Barracuda CloudGen Firewall Control Center license is automatically recovered using the getpar command used in the general ARM Template. This can be verified in the variables 'cgfCustomDataCC1' and 'cgfCustomDataCC2'.

## Deployment

For deployment fork this project and verify the provision.sh and provision-ha.sh scripts. The URL needs to be adapted for your deployment. 

## Post Deployment Configuration

After deployment a restore of the secondary HA unit is required. Preform the followin steps to complete this:

- Login via SSH on the primary HA unit: run the script '/root/restore-ha-lic.sh' on the primary HA unit
- Enter the SSH password of the HA cluster and let the script download and install the license on the HA cluster config
- This will connect to the secondary HA unit and restore the license
- Login via Firewall Admin on the primary HA unit and verify the HA license with the correct serial is present.
- Login via Firewall Admin on the secondary HA unit, verify the HA license and activate the box network in Control > Box
