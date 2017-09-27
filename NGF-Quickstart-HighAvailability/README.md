# Linux VM + data disk


This template allows you to deploy a simple Linux VM using a few different options for the Linux version, using the latest patched version.
Deploy a simple Linux VM using implicit MD for OS and for empty data disk. Public IP + NIC + MDs in an AZ.

This template uses a nested template for data disk creation. Default value for linkedTemplatesUrl is an Azure storage blob that contains the json.