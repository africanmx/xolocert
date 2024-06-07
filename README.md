# Xolocert

Xolocert is a certificate generation and verification tool designed to handle secure data operations using Bash scripting. It offers functionalities to create, verify, encrypt, and decrypt certificates, ensuring secure data handling.

## Features

- **Certificate Generation**: Create certificates with embedded configuration data.
- **Data Encryption**: Encrypt data using the embedded public key and algorithm specified in the certificate.
- **Data Decryption**: Decrypt data using the private key associated with the certificate.
- **Certificate Verification**: Verify the integrity and validity of certificates.

## Requirements

- Bash
- OpenSSL

Ensure you have Bash installed on your system. If not, you can install it using your system's package manager.

To install Xolocert, clone the repository and run the installation script:

```bash
git clone <repository_url>
cd xolocert
./install.sh
```

This will install Xolocert and set up the necessary files and directories.

## Usage

Once installed, you can use Xolocert from the command line. Here's how you can use its main functionalities:

1. **Certificate Generation**: Use the `--generate` flag to create a new certificate.

2. **Certificate Verification**: Use the `--verify` flag to verify the integrity and validity of a certificate.

3. **Data Encryption**: Use the `--encrypt` flag followed by the input and output file paths to encrypt data.

4. **Data Decryption**: Use the `--decrypt` flag followed by the input and output file paths to decrypt data.

5. **Help**: Use the `--help` flag to display usage information and available options.

Ensure you have necessary permissions to execute the script and access the files.

## License

Xolocert is distributed under the [MIT License](https://opensource.org/licenses/MIT). You can find the full license text in the [LICENSE](LICENSE) file.
