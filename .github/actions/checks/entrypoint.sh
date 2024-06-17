#!/bin/sh -l

AWS_REGION=$1
CONFIG_FILE=$2

# Read config file
MATRIX=$(jq -c . < $CONFIG_FILE)

# Extract compliance and exclude parameters from matrix
COMPLIANCE=$(echo $MATRIX | jq -r '.compliance')
EXCLUDE=$(echo $MATRIX | jq -r '.exclude')

# Run Prowler
prowler -r $AWS_REGION -compliance $COMPLIANCE --excluded-services $EXCLUDE
