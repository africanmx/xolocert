# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
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
RUN chmod +x install.sh && \
    ./install.sh

# Define environment variable
ENV PATH="/usr/local/xolocert:${PATH}"

# Run a bash shell by default
CMD ["bash"]
  