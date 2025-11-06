# Docker Learning Checklist

## ✅ Core Concepts Understanding

- [x] Understand what Docker is and its key benefits
- [x] Learn the difference between Docker containers and Virtual Machines
- [x] Understand Docker Images (blueprints/templates)
- [x] Understand Docker Containers (running instances)
- [x] Understand Dockerfile (image build instructions)
- [x] Understand Docker Registry (image storage)
- [ ] Understand Docker Volumes (persistent data)
- [ ] Understand Docker Networks (container communication)

## ✅ Installation & Setup

- [x] Install Docker (OrbStack)
- [x] Verify Docker installation with `docker --version`
- [x] Verify Docker is running with `docker ps`

## ✅ Working with Images

- [x] Search for images with `docker search`
- [x] Pull images from Docker Hub with `docker pull`
- [x] List local images with `docker images`
- [x] Remove images with `docker rmi`

## ✅ Working with Containers

- [x] Run a basic container with `docker run`
- [x] Run container in detached mode with `docker run -d`
- [x] Run container with custom name using `--name`
- [x] Run container with port mapping using `-p`
- [x] List running containers with `docker ps`
- [x] List all containers with `docker ps -a`
- [x] Stop a container with `docker stop`
- [x] Start a stopped container with `docker start`
- [x] Remove a container with `docker rm`
- [x] Force remove running container with `docker rm -f`

## ✅ Interactive Containers

- [x] Run container with interactive terminal using `-it`
- [x] Execute commands in running container with `docker exec`
- [x] View container logs with `docker logs`
- [x] Follow logs in real-time with `docker logs -f`

## ✅ Dockerfile Mastery

- [x] Understand basic Dockerfile structure
- [x] Use FROM instruction (base image)
- [x] Use LABEL instruction (metadata)
- [x] Use WORKDIR instruction (set working directory)
- [x] Use COPY instruction (copy files to image)
- [ ] Use ADD instruction (advanced copy)
- [x] Use RUN instruction (execute build commands)
- [x] Use EXPOSE instruction (document ports)
- [x] Use ENV instruction (environment variables)
- [x] Use CMD instruction (default command)
- [ ] Use ENTRYPOINT instruction (main command)
- [ ] Use VOLUME instruction (mount points)

## ✅ Building Custom Images

- [x] Build image from Dockerfile with `docker build`
- [x] Tag images properly with `-t`
- [x] Build with custom Dockerfile name using `-f`
- [x] Run custom built images

## ✅ Docker Volumes

- [ ] Understand volume types (named, bind mounts, tmpfs)
- [ ] Create named volumes with `docker volume create`
- [ ] Run containers with volumes using `-v`
- [ ] List volumes with `docker volume ls`
- [ ] Inspect volumes with `docker volume inspect`
- [ ] Remove volumes with `docker volume rm`
- [ ] Use bind mounts for development
- [ ] Use tmpfs mounts for temporary data

## ✅ Docker Networks

- [ ] Understand network types (bridge, host, none)
- [ ] List networks with `docker network ls`
- [ ] Create custom networks with `docker network create`
- [ ] Run containers on specific networks using `--network`
- [ ] Connect running containers to networks
- [ ] Disconnect containers from networks
- [ ] Inspect networks with `docker network inspect`
- [ ] Remove networks with `docker network rm`
- [ ] Enable container-to-container communication

## ✅ Docker Compose

- [ ] Understand Docker Compose purpose
- [ ] Create `docker-compose.yml` file
- [ ] Define services in compose file
- [ ] Configure ports in compose file
- [ ] Configure volumes in compose file
- [ ] Configure environment variables in compose file
- [ ] Configure networks in compose file
- [ ] Use `depends_on` for service dependencies
- [ ] Start services with `docker-compose up`
- [ ] Start services in detached mode with `-d`
- [ ] Build and start with `--build`
- [ ] Stop services with `docker-compose down`
- [ ] Remove volumes with `docker-compose down -v`
- [ ] View logs with `docker-compose logs`
- [ ] List running services with `docker-compose ps`
- [ ] Execute commands in services with `docker-compose exec`
- [ ] Restart services with `docker-compose restart`
- [ ] Scale services with `--scale`

## ✅ Best Practices

- [ ] Use official, slim base images
- [ ] Combine RUN commands to reduce layers
- [ ] Copy dependencies file first for better caching
- [ ] Create and use `.dockerignore` file
- [ ] Exclude unnecessary files (node_modules, .git, etc.)
- [ ] Implement multi-stage builds
- [ ] Run containers as non-root user
- [ ] Use proper environment variable management
- [ ] Optimize Dockerfile for smaller images
- [ ] Use `--no-cache-dir` with pip installs

## ✅ Security Practices

- [ ] Create non-root users in containers
- [ ] Use USER instruction in Dockerfile
- [ ] Set proper file ownership with `--chown`
- [ ] Avoid storing secrets in images
- [ ] Use environment variables for sensitive data

## ✅ Practical Examples Completed

- [ ] Simple web server with Nginx
- [ ] Python Flask application
- [ ] Full-stack application with Docker Compose
- [ ] Multi-container setup with database
- [ ] Container communication practice

## ✅ Troubleshooting Skills

- [ ] Debug containers that exit immediately
- [ ] Check container logs for errors
- [ ] Handle port conflicts
- [ ] Rebuild images without cache
- [ ] Debug container network connectivity
- [ ] Inspect networks for troubleshooting

## ✅ 7-Day Docker Challenge

### Day 1: Basics
- [x] Install Docker (OrbStack)
- [x] Run hello-world container
- [x] Try nginx and ubuntu containers
- [x] Practice basic commands

### Day 2: Images
- [x] Pull different images
- [x] Understand image layers
- [x] Create first Dockerfile
- [x] Build and run custom image

### Day 3: Volumes & Data
- [ ] Create named volumes
- [ ] Use bind mounts
- [ ] Persist database data
- [ ] Practice data management

### Day 4: Networks
- [ ] Create custom networks
- [ ] Run multi-container setup
- [ ] Practice container communication
- [ ] Debug network issues

### Day 5: Docker Compose
- [ ] Write first compose file
- [ ] Run multi-container app
- [ ] Practice compose commands
- [ ] Add services incrementally

### Day 6: Best Practices
- [ ] Optimize Dockerfiles
- [x] Implement multi-stage builds
- [ ] Apply security practices
- [ ] Create .dockerignore

### Day 7: Real Project
- [ ] Containerize a full-stack app
- [ ] Use Docker Compose
- [ ] Add database and cache layer
- [ ] Document the setup

## 🎯 Next Learning Goals

- [ ] Learn Kubernetes for container orchestration
- [ ] Explore Docker Swarm
- [ ] Integrate Docker with CI/CD pipelines
- [ ] Deploy containers to cloud platforms (AWS ECS, Google Cloud Run)
- [ ] Set up monitoring with Prometheus and Grafana
- [ ] Practice more complex microservices architectures
- [ ] Learn advanced security hardening techniques
- [ ] Explore container optimization techniques
- [ ] Build production-ready Docker workflows
- [ ] Contribute to Docker community projects
