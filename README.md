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

## 🏙️ Populating the City Catalog

The `voltwise-cloud` service includes a management command to sync the city catalog from external providers (e.g. **IBGE** for Brazil). It is **idempotent** — matching existing rows by `(country, external_id)` and performing bulk create/update, so it is safe to run on startup or on a schedule.

### Available Options

| Option | Description |
|--------|-------------|
| `--country <CODE>` | ISO alpha-2 country code to sync (e.g. `BR`). Without this flag, all active countries are synced. |
| `--if-empty` | Skips syncing when the city table already has rows — useful for a fast startup path. |

### Running with Docker Compose

After the stack is up, run the command inside the `voltwise-cloud` container:

```bash
# Sync all active countries
docker compose run --rm voltwise-cloud python manage.py sync_cities

# Sync a single country (e.g. Brazil)
docker compose run --rm voltwise-cloud python manage.py sync_cities --country BR

# Sync only if the table is empty (fast startup)
docker compose run --rm voltwise-cloud python manage.py sync_cities --if-empty
```

> **Note:** The `--rm` flag automatically removes the container after execution. If the `voltwise-cloud` service uses a **dev profile** with hot-reload, you can also `docker compose exec` into a running container instead:
>
> ```bash
> docker compose exec voltwise-cloud python manage.py sync_cities --country BR
> ```
