# VoltWise Docker & Setup

This repository is the core of the **VoltWise** ecosystem development environment. It contains the service orchestration via Docker Compose and the setup script to configure and keep all application repositories synchronized locally.

## 🚀 Getting Started

### 1. Preparing the Environment
First, ensure you have Docker, Docker Compose, and Git installed on your machine.

### 2. Configuring Environment Variables
Create your `.env` file based on the example file:
```bash
cp .env.example .env
```
Fill in the necessary variables in the `.env` file.

### 3. Downloading the Repositories
To run the project locally, you need to have all other VoltWise microservices downloaded side-by-side on your computer. To facilitate this, use the included setup script.

At the root of this project (`voltwise-docker`), run:
```bash
./setup.sh
```

> **Note:** This script will go back one directory level and clone (or update with `git pull`) all VoltWise repositories, such as `voltwise-cloud`, `voltwise-portal`, `voltwise-ocpp`, among others, placing them in the same parent folder as this Docker repository.

### 4. Running Services with Docker
With all repositories cloned and your `.env` file properly configured, you can start the entire environment using Docker Compose:

```bash
docker-compose up -d
```
To view the service logs, use:
```bash
docker-compose logs -f
```
To stop the services:
```bash
docker-compose down
```

## 📁 Expected Directory Structure
After running the `setup.sh` script, your base folder structure should look like this:

```text
📁 voltwise/
├── 📁 voltwise-docker/     <-- (You are here)
├── 📁 voltwise-cloud/
├── 📁 voltwise-portal/
├── 📁 voltwise-ocpp/
├── 📁 voltwise-simulator/
├── 📁 voltwise-core/
├── 📁 voltwise-docs/
├── 📁 voltwise-mobile/
└── 📁 voltwise-agent/
```

## 📜 Important Files
- `setup.sh`: Bash utility script to automate cloning and pulling all dependent projects.
- `docker-compose.yml`: Definition of all containers and services required to run the entire stack.
- `.env.example`: Template containing the parameters expected by docker-compose.
