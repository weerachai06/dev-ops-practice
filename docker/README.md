# Docker Learning Guide - Complete Overview

Let me give you a comprehensive guide to learning Docker from basics to advanced.

## What is Docker?

Docker is a platform that packages applications and their dependencies into containers - lightweight, portable units that run consistently across different environments. Think of it like shipping containers for software.

**Key Benefits:**
- **Consistency**: "Works on my machine" → "Works everywhere"
- **Isolation**: Apps don't interfere with each other
- **Lightweight**: Faster than VMs, uses less resources
- **Portability**: Run anywhere (dev laptop, staging, production)

---

## Docker vs Virtual Machines

**Virtual Machines:**
- Full OS for each VM
- Heavy (GBs of disk, slower startup)
- Hypervisor layer needed

**Docker Containers:**
- Share host OS kernel
- Lightweight (MBs, starts in seconds)
- More efficient resource usage

---

## Core Docker Concepts

### 1. **Images**
- Blueprint/template for containers
- Read-only snapshot with app + dependencies
- Built in layers (like Git commits)
- Stored in registries (Docker Hub, private registries)

### 2. **Containers**
- Running instance of an image
- Isolated process with own filesystem
- Can be started, stopped, deleted
- Ephemeral by default (data lost when removed)

### 3. **Dockerfile**
- Text file with instructions to build an image
- Like a recipe for your container

### 4. **Docker Registry**
- Storage for Docker images
- Docker Hub (public registry)
- Private registries (AWS ECR, Google GCR, Azure ACR)

### 5. **Volumes**
- Persistent data storage
- Survives container deletion
- Shared between containers

### 6. **Networks**
- How containers communicate
- Bridge, host, overlay networks

---

## Getting Started with Docker

### Installation (You already have OrbStack!)

OrbStack includes Docker, so you're ready! Verify:
```bash
docker --version
docker ps
```

### Basic Docker Commands

**Working with Images:**
```bash
# Search for images
docker search nginx

# Pull an image from Docker Hub
docker pull nginx

# List local images
docker images

# Remove an image
docker rmi nginx
```

**Working with Containers:**
```bash
# Run a container
docker run nginx

# Run in detached mode (background)
docker run -d nginx

# Run with custom name
docker run -d --name my-nginx nginx

# Run with port mapping (host:container)
docker run -d -p 8080:80 nginx

# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Stop a container
docker stop my-nginx

# Start a stopped container
docker start my-nginx

# Remove a container
docker rm my-nginx

# Remove running container (force)
docker rm -f my-nginx
```

**Interactive Containers:**
```bash
# Run with interactive terminal
docker run -it ubuntu bash

# Execute command in running container
docker exec -it my-nginx bash

# Attach local standard input, output, and error streams to a running container
docker attach <container_name_or_id>

# View container logs
docker logs my-nginx

# Follow logs in real-time
docker logs -f my-nginx
```

---

## Dockerfile - Building Custom Images

### Basic Dockerfile Structure

```dockerfile
# Base image
FROM ubuntu:22.04

# Metadata
LABEL maintainer="your-email@example.com"
LABEL version="1.0"

# Set working directory
WORKDIR /app

# Copy files from host to container
COPY . /app

# Run commands during build
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip3 install -r requirements.txt

# Expose port
EXPOSE 8000

# Environment variables
ENV APP_ENV=production

# Default command when container starts
CMD ["python3", "app.py"]
```

### Common Dockerfile Instructions

- **FROM**: Base image to start from
- **RUN**: Execute commands during build (install packages)
- **COPY**: Copy files from host to image
- **ADD**: Like COPY but can extract archives and download URLs
- **WORKDIR**: Set working directory
- **EXPOSE**: Document which ports the container listens on
- **ENV**: Set environment variables
- **CMD**: Default command to run (can be overridden)
- **ENTRYPOINT**: Main command (harder to override)
- **VOLUME**: Create mount point for volumes

### Building and Running Custom Images

```bash
# Build image from Dockerfile
docker build -t my-app:1.0 .

# Build with custom Dockerfile name
docker build -t my-app:1.0 -f Dockerfile.dev .

# Run your custom image
docker run -d -p 8000:8000 my-app:1.0
```

---

## Docker Volumes - Persistent Data

### Types of Volumes

**1. Named Volumes (Recommended):**
```bash
# Create a volume
docker volume create my-data

# Run container with volume
docker run -d -v my-data:/app/data nginx

# List volumes
docker volume ls

# Inspect volume
docker volume inspect my-data

# Remove volume
docker volume rm my-data
```

**2. Bind Mounts (Development):**
```bash
# Mount host directory to container
docker run -d -v /path/on/host:/path/in/container nginx

# Example: Mount current directory
docker run -d -v $(pwd):/app my-app
```

**3. Tmpfs Mounts (Temporary):**
```bash
# Store in memory only
docker run -d --tmpfs /app/cache nginx
```

---

## Docker Networks

### Network Types

**1. Bridge (Default):**
- Containers on same bridge can communicate
- Isolated from host network

**2. Host:**
- Container uses host's network directly
- No network isolation

**3. None:**
- No networking

### Working with Networks

```bash
# List networks
docker network ls

# Create custom network
docker network create my-network

# Run container on specific network
docker run -d --network my-network --name web nginx

# Connect running container to network
docker network connect my-network web

# Disconnect from network
docker network disconnect my-network web

# Inspect network
docker network inspect my-network

# Remove network
docker network rm my-network
```

### Container Communication

```bash
# Create network
docker network create app-network

# Run database container
docker run -d --network app-network --name db postgres

# Run app container (can access db by name)
docker run -d --network app-network --name app my-app
# In app, connect to: postgresql://db:5432
```

---

## Docker Compose - Multi-Container Applications

Docker Compose manages multi-container applications with a single YAML file.

### docker-compose.yml Example

```yaml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "8000:8000"
    volumes:
      - .:/app
    environment:
      - DATABASE_URL=postgresql://db:5432/myapp
    depends_on:
      - db
    networks:
      - app-network

  db:
    image: postgres:15
    environment:
      - POSTGRES_DB=myapp
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - app-network

  redis:
    image: redis:7-alpine
    networks:
      - app-network

volumes:
  db-data:

networks:
  app-network:
    driver: bridge
```

### Docker Compose Commands

```bash
# Start all services
docker-compose up

# Start in detached mode
docker-compose up -d

# Build and start
docker-compose up --build

# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v

# View logs
docker-compose logs

# Follow logs for specific service
docker-compose logs -f web

# List running services
docker-compose ps

# Execute command in service
docker-compose exec web bash

# Restart a service
docker-compose restart web

# Scale a service
docker-compose up -d --scale web=3
```

---

## Best Practices

### 1. **Dockerfile Optimization**

```dockerfile
# ❌ BAD: Large image, slow builds
FROM ubuntu:22.04
RUN apt-get update
RUN apt-get install -y python3
RUN apt-get install -y pip
COPY . /app
RUN pip install -r requirements.txt

# ✅ GOOD: Smaller image, cached layers
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "app.py"]
```

**Key Principles:**
- Use official, slim base images
- Combine RUN commands to reduce layers
- Copy dependencies file first (better caching)
- Use `.dockerignore` to exclude unnecessary files
- Run as non-root user for security

### 2. **.dockerignore File**

```
# .dockerignore
node_modules
.git
.env
*.log
.DS_Store
__pycache__
*.pyc
.pytest_cache
coverage/
dist/
build/
```

### 3. **Multi-Stage Builds**

```dockerfile
# Build stage
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Production stage
FROM node:18-slim
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
CMD ["node", "dist/index.js"]
```

### 4. **Security Best Practices**

```dockerfile
# Run as non-root user
FROM python:3.11-slim

RUN useradd -m -u 1000 appuser
USER appuser

WORKDIR /home/appuser/app
COPY --chown=appuser:appuser . .

CMD ["python", "app.py"]
```

### 5. **Environment Variables**

```bash
# Pass environment variables
docker run -e DATABASE_URL=postgresql://localhost my-app

# Use .env file
docker run --env-file .env my-app
```

---

## Practical Examples

### Example 1: Simple Web Server

```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
EXPOSE 80
```

```bash
docker build -t my-website .
docker run -d -p 8080:80 my-website
# Visit http://localhost:8080
```

### Example 2: Python Flask App

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["flask", "run", "--host=0.0.0.0"]
```

### Example 3: Full Stack with Docker Compose

```yaml
version: '3.8'

services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    depends_on:
      - backend

  backend:
    build: ./backend
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://postgres:password@db:5432/myapp
    depends_on:
      - db

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=myapp
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  postgres-data:
```

---

## Learning Resources

### Free Courses
- **Docker Official Documentation** (https://docs.docker.com)
  - Best starting point
  - Comprehensive and up-to-date

- **Play with Docker** (https://labs.play-with-docker.com)
  - Free online Docker playground
  - No installation needed

- **freeCodeCamp YouTube**: "Docker Tutorial for Beginners" (2+ hours)

### Paid Courses
- **Udemy**: "Docker Mastery" by Bret Fisher (highly rated)
- **A Cloud Guru**: "Docker Deep Dive"
- **Pluralsight**: "Docker and Kubernetes: The Complete Guide"

### Books
- **"Docker Deep Dive"** by Nigel Poulton
- **"Docker in Action"** by Jeff Nickoloff
- **"Docker for Developers"** by Richard Bullington-McGuire

### Practice Projects
1. **Containerize a personal project**
2. **Set up WordPress with Docker Compose** (WordPress + MySQL)
3. **Build a microservices app** (3-4 containers communicating)
4. **Create CI/CD pipeline** with Docker
5. **Deploy to cloud** (AWS ECS, Google Cloud Run)

---

## 7-Day Docker Challenge

### Day 1: Basics
- Install Docker (OrbStack)
- Run your first container: `docker run hello-world`
- Try nginx, ubuntu containers
- Practice basic commands

### Day 2: Images
- Pull different images
- Understand image layers
- Create your first Dockerfile
- Build and run custom image

### Day 3: Volumes & Data
- Create named volumes
- Use bind mounts
- Persist database data
- Practice data management

### Day 4: Networks
- Create custom networks
- Run multi-container setup
- Practice container communication
- Debug network issues

### Day 5: Docker Compose
- Write first compose file
- Run multi-container app
- Practice compose commands
- Add services incrementally

### Day 6: Best Practices
- Optimize Dockerfiles
- Multi-stage builds
- Security practices
- Create .dockerignore

### Day 7: Real Project
- Containerize a full-stack app
- Use Docker Compose
- Add database, cache layer
- Document your setup

---

## Common Issues & Solutions

**Issue**: Container exits immediately
```bash
# Check logs
docker logs <container-id>
# Run interactively to debug
docker run -it <image> sh
```

**Issue**: Port already in use
```bash
# Use different host port
docker run -p 8081:80 nginx
# Or find and stop conflicting service
lsof -i :8080
```

**Issue**: Image build fails
```bash
# Build with no cache
docker build --no-cache -t my-app .
# Check Dockerfile syntax
```

**Issue**: Container can't connect to another
```bash
# Ensure both on same network
docker network inspect <network-name>
# Use container name, not localhost
```

---

## Next Steps After Docker

Once comfortable with Docker:
1. **Kubernetes**: Container orchestration
2. **Docker Swarm**: Simpler orchestration
3. **CI/CD Integration**: GitLab CI, GitHub Actions
4. **Cloud Deployments**: AWS ECS, Google Cloud Run
5. **Monitoring**: Prometheus, Grafana for containers

---

Would you like me to:
1. Create a hands-on project to practice Docker?
2. Explain any specific Docker concept in more detail?
3. Show you how to containerize a specific type of application?
4. Create a Docker cheat sheet artifact for quick reference?