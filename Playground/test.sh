#!/bin/bash
# A simple Azure Storage example script

export AZURE_STORAGE_ACCOUNT=""
export AZURE_STORAGE_KEY=""

#export container_name=<container_name>
#export blob_name=<blob_name>
#export file_to_upload=<file_to_upload>
#export destination_file=<destination_file>

#echo "Creating the container..."
#az storage container create --name $container_name

#echo "Uploading the file..."
#az storage blob upload --container-name $container_name --file $file_to_upload --name $blob_name

echo "Listing the blobs..."
az storage blob list --container-name $container_name --output table
