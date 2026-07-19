#!/bin/bash

# ============================================================
# Docker Engine Installation Script for Ubuntu
# Official Installation Method (APT Repository)
# ============================================================

set -e

echo "==========================================="
echo " Docker Engine Installation for Ubuntu"
echo "==========================================="

# ------------------------------------------------------------
# Remove conflicting Docker packages
# ------------------------------------------------------------
echo "Removing conflicting packages (if installed)..."

sudo apt remove -y $(
    dpkg --get-selections \
    docker.io \
    docker-compose \
    docker-compose-v2 \
    docker-doc \
    podman-docker \
    containerd \
    runc | cut -f1
)

# ------------------------------------------------------------
# Update package index and install prerequisites
# ------------------------------------------------------------
echo "Installing required packages..."

sudo apt update
sudo apt install -y ca-certificates curl

# ------------------------------------------------------------
# Create keyrings directory
# ------------------------------------------------------------
echo "Creating keyrings directory..."

sudo install -m 0755 -d /etc/apt/keyrings

# ------------------------------------------------------------
# Download Docker's official GPG key
# ------------------------------------------------------------
echo "Adding Docker GPG key..."

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc

# ------------------------------------------------------------
# Add Docker APT repository
# ------------------------------------------------------------
echo "Adding Docker repository..."

sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# ------------------------------------------------------------
# Update package index
# ------------------------------------------------------------
echo "Updating package index..."

sudo apt update

# ------------------------------------------------------------
# Install Docker Engine
# ------------------------------------------------------------
echo "Installing Docker Engine..."

sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# ------------------------------------------------------------
# Start Docker service if it is not running
# ------------------------------------------------------------
echo "Checking Docker service..."

if ! systemctl is-active --quiet docker; then
    sudo systemctl start docker
fi

# ------------------------------------------------------------
# Display Docker service status
# ------------------------------------------------------------
echo
echo "Docker service status:"
sudo systemctl status docker --no-pager

# ------------------------------------------------------------
# Verify Docker installation
# ------------------------------------------------------------
echo
echo "Running Docker test container..."
sudo docker run hello-world

# ------------------------------------------------------------
# Configure Docker for current user (optional)
# ------------------------------------------------------------
echo
echo "Adding current user to the docker group..."

sudo usermod -aG docker "$USER"

# ------------------------------------------------------------
# Display installed versions
# ------------------------------------------------------------
echo
echo "Docker Version:"
docker --version

echo
echo "Docker Compose Version:"
docker compose version

echo
echo "==========================================="
echo " Docker has been installed successfully!"
echo "==========================================="
echo
echo "To run Docker without sudo:"
echo "1. Log out and log back in"
echo "   OR"
echo "2. Run: newgrp docker"
echo
echo "Test Docker again:"
echo "docker run hello-world"
