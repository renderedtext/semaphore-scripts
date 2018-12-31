#!/bin/bash

####
# Description: This script will install, cache and start DynamoDB on Semaphore.
#
# Runs on: Standard and Docker platforms
#
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/semaphore-dynamodb-setup.sh && bash semaphore-dynamodb-setup.sh
#
# Note:
####

set -e
dynamodb_archive=$SEMAPHORE_CACHE_DIR/dynamodb_local_latest.tar.gz
dynamodb_folder=$SEMAPHORE_PROJECT_DIR/DynamoDBLocal

if ! [ -f $dynamodb_archive ]
then
    echo "DynamoDBLocal not found in cache, downloading..."
    curl -o $dynamodb_archive -L https://s3.eu-central-1.amazonaws.com/dynamodb-local-frankfurt/dynamodb_local_latest.tar.gz
else
    echo "DynamoDBLocal found in cache, using local version..."
fi

echo "Extracting DynamoDBLocal archive..."
mkdir -p $dynamodb_folder
tar -xvzf $dynamodb_archive --directory $dynamodb_folder

echo "Starting DynamoDBLocal..."
java -Djava.library.path=$dynamodb_folder/DynamoDBLocal_lib -jar $dynamodb_folder/DynamoDBLocal.jar -sharedDb &

echo "Listing tables..."
aws dynamodb list-tables --endpoint-url http://localhost:8000