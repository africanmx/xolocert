# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Make the install.sh script executable and run it
COPY ../install.sh /usr/src/app/install.sh
RUN chmod +x /usr/src/app/install.sh && \
    /usr/src/app/install.sh

# Add xolocert to PATH
ENV PATH="/usr/local/xolocert:${PATH}"

# Run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
