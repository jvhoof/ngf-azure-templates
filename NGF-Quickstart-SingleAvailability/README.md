# Barracuda Next Gen Firewall F Series ARM Template

<img src="https://cudajvhoof.visualstudio.com/_apis/public/build/definitions/74ff283c-fcb5-4060-b1f2-f377e03be483/3/badge"/>

Using the this Azure Resource Manager (ARM) template the Barracuda Next Gen Firewall F Series is deployed in a new VNET. Deployment is done with in a one-armed fashion where north-south, east-west and VPN tunnel traffic can be intercepted and inspected based on the User Defined Routing that is attached to the subnets that need this control. Do not apply any UDR to the subnet where the NGF is located that points back to the NGF. This will cause routing loops.

To adapt this deployment to your requirements you can adapth the azuredeploy.paramters.json file or adapth the deployment script in Powershell or Azure CLI (Bash).

