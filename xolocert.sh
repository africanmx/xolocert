#!/bin/bash

CERT_PATH="$HOME/xolocert"
PRIVATE_KEY_PATH="$HOME/.xolocert_private_key.pem"
PUBLIC_KEY_PATH="$HOME/.xolocert_public_key.pem"
SIGNATURE_PATH="$HOME/xolocert_signature.bin"

# Function to generate the xolocert
generate_xolocert() {
    # Check if keys already exist
    if [ -f "$PRIVATE_KEY_PATH" ] || [ -f "$PUBLIC_KEY_PATH" ]; then
        echo "Error: Key files already exist. If you want to generate new keys, please remove existing key files first."
        exit 1
    fi

    # Generate private key
    openssl genpkey -algorithm RSA -out "$PRIVATE_KEY_PATH" -pkeyopt rsa_keygen_bits:2048 > /dev/null 2>&1 || { echo "Error: Failed to generate private key."; exit 1; }

    # Generate public key
    openssl rsa -pubout -in "$PRIVATE_KEY_PATH" -out "$PUBLIC_KEY_PATH" > /dev/null 2>&1 || { echo "Error: Failed to generate public key."; exit 1; }

    # Generate certificate without printing the content
    CERT_ID=$(uuidgen)
    CERT_BODY=$(openssl rand -base64 1024)
    CONFIG_DATA="PUBLIC_KEY: $(cat $PUBLIC_KEY_PATH)\nALGORITHM: AES-256\n"
    echo -e "$CERT_ID\n$CERT_BODY\n$CONFIG_DATA" > $CERT_PATH || { echo "Error: Failed to generate xolocert."; exit 1; }
    openssl dgst -sha256 -sign $PRIVATE_KEY_PATH -out $SIGNATURE_PATH $CERT_PATH > /dev/null || { echo "Error: Failed to generate xolocert signature."; exit 1; }

    # Display progress bar while generating
    echo -n "Generating xolocert: ["
    for i in {1..10}; do
        echo -n "#"
        sleep 0.1
    done
    echo -n "]"
    echo " xolocert generated: $CERT_PATH"
}

# Function to verify the xolocert
verify_xolocert() {
    if [ ! -f "$CERT_PATH" ]; then
        echo "Error: xolocert is empty or does not exist"
        exit 1
    fi

    openssl dgst -sha256 -verify $PUBLIC_KEY_PATH -signature $SIGNATURE_PATH $CERT_PATH
    if [ $? -eq 0 ]; then
        echo "xolocert is valid"
    else
        echo "xolocert is invalid"
    fi
}

# Function to encrypt data
encrypt_data() {
    # Extract the AES key from the certificate
    AES_KEY=$(sed -n '2,24p' $CERT_PATH)

    # Encrypt the file using AES-256 with a key derivation function
    openssl enc -aes-256-cbc -pbkdf2 -in "$1" -out "$2" -pass pass:"$AES_KEY"

    echo "File encrypted successfully!"
}

# Function to decrypt data
decrypt_data() {
    # Extract the AES key from the certificate
    AES_KEY=$(sed -n '2,24p' $CERT_PATH)

    # Decrypt the file using AES-256
    openssl enc -d -aes-256-cbc -pbkdf2 -in "$1" -out "$2" -pass pass:"$AES_KEY"

    echo "File decrypted successfully!"
}

# Main function
main() {
    case "$1" in
        --generate)
            generate_xolocert
            ;;
        --verify)
            verify_xolocert
            ;;
        --encrypt)
            if [[ -z "$2" || -z "$3" ]]; then
                echo "Usage: $0 --encrypt <input_file> <output_file>"
                exit 1
            fi
            encrypt_data "$2" "$3"
            ;;
        --decrypt)
            if [[ -z "$2" || -z "$3" ]]; then
                echo "Usage: $0 --decrypt <input_file> <output_file>"
                exit 1
            fi
            decrypt_data "$2" "$3"
            ;;
        --help)
            show_help
            ;;
        *)
            echo "Usage: $0 {--generate|--verify|--encrypt <input_file> <output_file>|--decrypt <input_file> <output_file>|--help}"
            exit 1
            ;;
    esac
}

# Function to display help information
show_help() {
    echo "Usage: $0 {--generate|--verify|--encrypt <input_file> <output_file>|--decrypt <input_file> <output_file>|--export-private-key|--silent|--help}"
    echo "Options:"
    echo "  --generate            Generate xolocert"
    echo "  --verify              Verify xolocert"
    echo "  --encrypt <input_file> <output_file>"
    echo "                        Encrypt data"
    echo "  --decrypt <input_file> <output_file>"
    echo "                        Decrypt data"
    echo "  --export-private-key  Export private key"
    echo "  --silent              Silent mode (no output)"
    echo "  --help                Display this help message"
}

main "$@"
