#!/bin/bash

# Usage: encrypt_data.sh <certificate_file> <input_file> <output_file>

# Check the number of arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: encrypt_data.sh <certificate_file> <input_file> <output_file>"
    exit 1
fi

# Certificate file
CERT_FILE="$1"

# Input file
INPUT_FILE="$2"

# Output file
OUTPUT_FILE="$3"

# Extract the public key
PUBLIC_KEY=$(sed -n '/^PUBLIC_KEY: -----BEGIN PUBLIC KEY-----$/,/^-----END PUBLIC KEY-----$/p' $CERT_FILE)

# Extract the AES key from the certificate
AES_KEY=$(sed -n '2,23p' $CERT_FILE)

# Encrypt the file using AES-256
openssl enc -aes-256-cbc -in $INPUT_FILE -out $OUTPUT_FILE -pass pass:"$AES_KEY"

# Encrypt the AES key using the public key
ENCRYPTED_KEY=$(echo "$AES_KEY" | openssl rsautl -encrypt -pubin -inkey <(echo "$PUBLIC_KEY"))

# Append the encrypted key to the output file
echo "$ENCRYPTED_KEY" >> $OUTPUT_FILE

echo "File encrypted successfully!"
