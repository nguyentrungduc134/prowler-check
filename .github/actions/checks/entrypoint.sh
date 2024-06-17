#!/bin/sh -l

AWS_REGION=
CONFIG_FILE=

# Read config file
MATRIX=

# Extract compliance and exclude parameters from matrix
COMPLIANCE=
EXCLUDE=

# Run Prowler
prowler -r  -c  --excluded-services 
