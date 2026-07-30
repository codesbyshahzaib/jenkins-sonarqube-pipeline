#!/bin/bash
set -e


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

echo "Installing required packages..."

sudo apt update
sudo apt install -y ca-certificates curl

echo "Creating keyrings directory..."

sudo install -m 0755 -d /etc/apt/keyrings

echo "Adding Docker GPG key..."

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "Adding Docker repository..."

sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

echo "Updating package index..."

sudo apt update

echo "Installing Docker Engine..."

sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

echo "Checking Docker service..."

if ! systemctl is-active --quiet docker; then
    sudo systemctl start docker
fi

echo "Docker service status:"
sudo systemctl status docker --no-pager

echo "Running Docker test container..."
sudo docker run hello-world

echo "Adding current user to the docker group..."

sudo usermod -aG docker "$USER"

docker --version

docker compose version


