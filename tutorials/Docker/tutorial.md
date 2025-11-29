# Docker Tutorial: Installation & Basic Commands

> A comprehensive guide to installing Docker, registering on Docker Hub, and mastering essential Docker commands.

## Table of Contents

1. [Installing Docker](#installing-docker)
   - [Linux](#linux)
   - [Windows](#windows)
   - [macOS](#macos)
2. [Docker Hub Registration](#docker-hub-registration)
3. [Basic Docker Commands](#basic-docker-commands)
4. [Working with Images](#working-with-images)
5. [Working with Containers](#working-with-containers)
6. [Docker Compose Basics](#docker-compose-basics)

## Installing Docker

### Linux

#### Ubuntu / Debian

1. **Update package index and install prerequisites:**
   ```bash
   sudo apt-get update
   sudo apt-get install ca-certificates curl gnupg lsb-release
   ```

2. **Add Docker's official GPG key:**
   ```bash
   sudo mkdir -m 0755 -p /etc/apt/keyrings
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   ```

3. **Set up the repository:**
   ```bash
   echo \
     "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```

4. **Install Docker Engine:**
   ```bash
   sudo apt-get update
   sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
   ```

5. **Verify installation:**
   ```bash
   sudo docker run hello-world
   ```

6. **Optional: Add user to docker group (to run without sudo):**
   ```bash
   sudo usermod -aG docker $USER
   newgrp docker
   ```

### Windows

#### Windows 10/11 Pro, Enterprise, or Education

1. **System Requirements:**
   - Windows 10 64-bit: Pro, Enterprise, or Education (Build 19041 or higher)
   - Windows 11 64-bit: Pro, Enterprise, or Education
   - WSL 2 enabled
   - Hyper-V and Containers Windows features enabled

2. **Enable WSL 2:**
   ```powershell
   # Open PowerShell as Administrator
   wsl --install
   ```

3. **Download Docker Desktop:**
   - Visit: https://www.docker.com/products/docker-desktop
   - Download "Docker Desktop for Windows"

4. **Install Docker Desktop:**
   - Run the installer (Docker Desktop Installer.exe)
   - Follow the installation wizard
   - Check "Use WSL 2 instead of Hyper-V" option
   - Restart your computer when prompted

5. **Start Docker Desktop:**
   - Launch Docker Desktop from Start menu
   - Wait for Docker to start (whale icon in system tray)

6. **Verify installation:**
   ```powershell
   docker --version
   docker run hello-world
   ```

#### Windows 10/11 Home

- Docker Desktop now supports Windows Home with WSL 2
- Follow the same steps as above
- Ensure WSL 2 is installed and set as default

### macOS

#### Intel Macs & Apple Silicon (M1/M2/M3)

1. **System Requirements:**
   - macOS 11 (Big Sur) or later
   - At least 4GB RAM

2. **Download Docker Desktop:**
   - Visit: https://www.docker.com/products/docker-desktop
   - Choose the correct version:
     - **Intel chip**: "Mac with Intel chip"
     - **Apple chip**: "Mac with Apple chip"

3. **Install Docker Desktop:**
   - Open the downloaded `.dmg` file
   - Drag Docker.app to Applications folder
   - Launch Docker from Applications

4. **Grant permissions:**
   - Docker Desktop will ask for system permissions
   - Enter your password when prompted

5. **Verify installation:**
   ```bash
   docker --version
   docker run hello-world
   ```

#### Alternative: Homebrew Installation

```bash
brew install --cask docker
```

## Docker Hub Registration

Docker Hub is the default public registry for storing and sharing Docker images.

### Creating an Account

1. **Visit Docker Hub:**
   - Go to: https://hub.docker.com/signup

2. **Sign up:**
   - Enter your Docker ID (username)
   - Provide email address
   - Create a strong password
   - Verify your email

3. **Login from CLI:**
   ```bash
   docker login
   ```
   - Enter your Docker ID and password
   - Credentials are stored in `~/.docker/config.json`

4. **Logout:**
   ```bash
   docker logout
   ```

### Creating a Repository

1. **On Docker Hub website:**
   - Click "Create Repository"
   - Choose a name (e.g., `myapp`)
   - Set visibility (Public or Private)
   - Add description (optional)

2. **Push an image to your repository:**
   ```bash
   # Tag your image with your Docker ID
   docker tag myapp:latest yourdockerid/myapp:latest
   
   # Push to Docker Hub
   docker push yourdockerid/myapp:latest
   ```

## Basic Docker Commands

### Getting Help

```bash
# General help
docker --help

# Help for specific command
docker run --help
docker build --help
```

### Version and System Info

```bash
# Check Docker version
docker --version
docker version

# Display system-wide information
docker info

# Check disk usage
docker system df

# Remove unused data
docker system prune
docker system prune -a  # Remove all unused images
```

## Working with Images

### Pulling Images

```bash
# Pull latest version of an image
docker pull nginx

# Pull specific version
docker pull nginx:1.25-alpine

# Pull from a specific registry
docker pull ghcr.io/owner/image:tag
```

### Listing Images

```bash
# List all local images
docker images
docker image ls

# List all images (including intermediate)
docker images -a

# Filter images
docker images --filter "dangling=true"
```

### Building Images

```bash
# Build from Dockerfile in current directory
docker build -t myapp:latest .

# Build with custom Dockerfile name
docker build -f Dockerfile.prod -t myapp:prod .

# Build with build arguments
docker build --build-arg NODE_VERSION=18 -t myapp:latest .

# Build without cache
docker build --no-cache -t myapp:latest .
```

### Managing Images

```bash
# Tag an image
docker tag myapp:latest myapp:v1.0.0

# Remove an image
docker rmi myapp:latest
docker image rm myapp:latest

# Remove all unused images
docker image prune

# Remove all images
docker rmi $(docker images -q)

# Inspect image details
docker image inspect nginx:latest

# View image history (layers)
docker history nginx:latest
```

### Pushing Images

```bash
# Push to Docker Hub
docker push yourusername/myapp:latest

# Push to private registry
docker tag myapp:latest registry.example.com/myapp:latest
docker push registry.example.com/myapp:latest
```

## Working with Containers

### Running Containers

```bash
# Run a container (pulls image if not available locally)
docker run nginx

# Run in detached mode (background)
docker run -d nginx

# Run with a custom name
docker run --name my-nginx -d nginx

# Run with port mapping (host:container)
docker run -d -p 8080:80 nginx

# Run with environment variables
docker run -d -e "MYSQL_ROOT_PASSWORD=secret" mysql

# Run with volume mount
docker run -d -v /host/path:/container/path nginx

# Run with interactive terminal
docker run -it ubuntu bash

# Run and remove container when stopped
docker run --rm -it ubuntu bash

# Run with resource limits
docker run -d --memory="512m" --cpus="1.0" nginx

# Run with restart policy
docker run -d --restart=always nginx
docker run -d --restart=unless-stopped nginx
```

### Listing Containers

```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# List only container IDs
docker ps -q

# List with specific format
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"

# Filter containers
docker ps --filter "status=exited"
docker ps --filter "name=nginx"
```

### Container Management

```bash
# Start a stopped container
docker start container_name

# Stop a running container
docker stop container_name

# Restart a container
docker restart container_name

# Pause a container
docker pause container_name

# Unpause a container
docker unpause container_name

# Kill a container (force stop)
docker kill container_name

# Remove a container
docker rm container_name

# Remove a running container (force)
docker rm -f container_name

# Remove all stopped containers
docker container prune
```

### Inspecting Containers

```bash
# View container logs
docker logs container_name

# Follow logs in real-time
docker logs -f container_name

# Show last N lines
docker logs --tail 100 container_name

# Show logs with timestamps
docker logs -t container_name

# Inspect container details
docker inspect container_name

# View container resource usage
docker stats
docker stats container_name

# View running processes
docker top container_name
```

### Executing Commands in Containers

```bash
# Execute a command in running container
docker exec container_name ls /app

# Open interactive shell (you are entering the container)
docker exec -it container_name bash
docker exec -it container_name sh  # for Alpine-based images

# Execute as specific user
docker exec -u root -it container_name bash

# Execute with environment variables
docker exec -e VAR=value container_name env
```

### Copying Files

```bash
# Copy from container to host
docker cp container_name:/path/in/container /path/on/host

# Copy from host to container
docker cp /path/on/host container_name:/path/in/container
```

### Networking

```bash
# List networks
docker network ls

# Create a network
docker network create my-network

# Run container on specific network
docker run -d --network my-network --name app nginx

# Connect container to network
docker network connect my-network container_name

# Disconnect container from network
docker network disconnect my-network container_name

# Inspect network
docker network inspect my-network

# Remove network
docker network rm my-network
```

### Volumes

```bash
# List volumes
docker volume ls

# Create a volume
docker volume create my-data

# Run container with volume
docker run -d -v my-data:/data nginx

# Inspect volume
docker volume inspect my-data

# Remove volume
docker volume rm my-data

# Remove all unused volumes
docker volume prune
```

## Docker Compose Basics

Docker Compose allows you to define and run multi-container applications.

### Installation

Docker Compose is included with Docker Desktop. On Linux, verify:

```bash
docker compose version
```

### Basic Commands

```bash
# Start services (from directory with docker-compose.yml)
docker compose up

# Start in detached mode
docker compose up -d

# Build images before starting
docker compose up --build

# Stop services
docker compose stop

# Stop and remove containers, networks
docker compose down

# Stop and remove everything including volumes
docker compose down -v

# View logs
docker compose logs
docker compose logs -f  # follow logs

# List running services
docker compose ps

# Execute command in service
docker compose exec web bash

# Scale a service
docker compose up -d --scale api=3

# Restart services
docker compose restart

# Pull latest images
docker compose pull
```

### Example docker-compose.yml

```yaml
version: '3.9'

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html
    depends_on:
      - api

  api:
    build: ./api
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/mydb
    ports:
      - "3000:3000"
    depends_on:
      - db

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=pass
      - POSTGRES_DB=mydb
    volumes:
      - db-data:/var/lib/postgresql/data

volumes:
  db-data:
```

## Common Workflows

### Development Workflow

```bash
# 1. Create Dockerfile
cat > Dockerfile <<EOF
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
EOF

# 2. Build image
docker build -t myapp:dev .

# 3. Run container with live reload
docker run -d \
  -p 3000:3000 \
  -v $(pwd):/app \
  -v /app/node_modules \
  --name myapp-dev \
  myapp:dev

# 4. View logs
docker logs -f myapp-dev

# 5. Clean up
docker stop myapp-dev
docker rm myapp-dev
```

### Production Deployment

```bash
# 1. Build optimized image
docker build -t myapp:1.0.0 -f Dockerfile.prod .

# 2. Tag for registry
docker tag myapp:1.0.0 registry.example.com/myapp:1.0.0

# 3. Push to registry
docker push registry.example.com/myapp:1.0.0

# 4. Pull and run on server
docker pull registry.example.com/myapp:1.0.0
docker run -d \
  --name myapp \
  --restart=unless-stopped \
  -p 80:3000 \
  registry.example.com/myapp:1.0.0
```

## Troubleshooting Tips

### Container won't start

```bash
# Check logs
docker logs container_name

# Check last 50 lines
docker logs --tail 50 container_name

# Inspect container configuration
docker inspect container_name
```

### Permission issues

```bash
# Run as specific user
docker run --user $(id -u):$(id -g) myimage

# Linux: Add user to docker group
sudo usermod -aG docker $USER
newgrp docker
```

### Network connectivity issues

```bash
# Check network configuration
docker network inspect bridge

# Run with host network (Linux only)
docker run --network host myimage
```

### Disk space issues

```bash
# Check disk usage
docker system df

# Clean up
docker system prune -a --volumes
```

### Port already in use

```bash
# Find process using port (Linux/Mac)
sudo lsof -i :8080

# Use different host port
docker run -p 8081:80 nginx
```

## Best Practices

1. **Always specify image tags** - avoid using `latest`
2. **Use `.dockerignore`** - exclude unnecessary files from build context
3. **Minimize layers** - combine RUN commands with `&&`
4. **Use multi-stage builds** - for smaller production images
5. **Run as non-root user** - improve security
6. **Health checks** - add HEALTHCHECK to Dockerfile
7. **Named volumes** - use named volumes instead of bind mounts in production
8. **Environment variables** - use env vars for configuration
9. **Clean up** - regularly run `docker system prune`
10. **Scan images** - use `docker scout` or Trivy for vulnerability scanning

## Additional Resources

- **Official Docker Documentation**: https://docs.docker.com
- **Docker Hub**: https://hub.docker.com
- **Dockerfile Reference**: https://docs.docker.com/engine/reference/builder/
- **Docker Compose Reference**: https://docs.docker.com/compose/compose-file/
- **Play with Docker**: https://labs.play-with-docker.com (online playground)

## Quick Reference Card

```bash
# IMAGES
docker pull <image>              # Download image
docker build -t <name> .         # Build image
docker images                    # List images
docker rmi <image>               # Remove image

# CONTAINERS
docker run <image>               # Create and start container
docker ps                        # List running containers
docker ps -a                     # List all containers
docker stop <container>          # Stop container
docker start <container>         # Start container
docker restart <container>       # Restart container
docker rm <container>            # Remove container
docker logs <container>          # View logs
docker exec -it <container> bash # Execute command

# CLEANUP
docker system prune              # Remove unused data
docker system prune -a           # Remove all unused images
docker volume prune              # Remove unused volumes

# COMPOSE
docker compose up -d             # Start services
docker compose down              # Stop services
docker compose logs -f           # View logs
docker compose ps                # List services
```

Happy Dockerizing! 🐳
