# Xolocert API

This is a FastAPI application that provides endpoints to generate and verify certificates using the xolocert system. The application is designed to run inside a Docker container and is secured with Bearer token authentication.

## Requirements

- Docker
- Docker Compose

## Setup

1. **Clone the repository and navigate to the `/app` directory:**

    ```sh
    git clone <your-repo-url>
    cd xolocert/app
    ```

2. **Generate a secure random token for authentication:**

    ```sh
    openssl rand -hex 32
    ```

   Copy the generated token and add it to the `.env` file:

    ```plaintext
    BEARER_TOKEN=your_secure_bearer_token
    ```

3. **Build and run the Docker Compose setup:**

    ```sh
    docker-compose up --build
    ```

## API Endpoints

The API provides the following endpoints:

### Generate Certificate

**Endpoint:**

```plaintext
POST /generate_certificate
```

Description:

Generates a new certificate using the xolocert system.

Request:

```sh
curl -X POST "http://localhost:8000/generate_certificate" -H "Authorization: Bearer your_secure_bearer_token"
```

Response:

```json
{
  "message": "Certificate generated",
  "output": "<output from xolocert --create>"
}
```

Verify Certificate
Endpoint:

```plaintext
GET /verify_certificate
```

Description:

Verifies the integrity and validity of the existing certificate using the xolocert system.

Request:

```sh
curl -X GET "http://localhost:8000/verify_certificate" -H "Authorization: Bearer your_secure_bearer_token"
```

Response:

```json
{
  "message": "Certificate verified",
  "output": "<output from xolocert --verify>"
}
```

Configuration
The application uses environment variables for configuration. Ensure you have a .env file in the root of your project with the following content:

```plaintext
BEARER_TOKEN=your_secure_bearer_token
```

Replace your_secure_bearer_token with the secure random token generated in step 2.

### Running Tests

To run tests, ensure that the Docker containers are running and use a tool like curl or Postman to interact with the API endpoints.

### Help

For any issues or questions, please refer to the documentation or open an issue on the GitHub repository.

### License

This project is licensed under the MIT License. See the LICENSE file for details.
