# Inception

A comprehensive Docker Compose project that orchestrates a complete WordPress infrastructure with Nginx web server, MariaDB database, and secure containerization practices. This project demonstrates modern DevOps practices for the 42 School curriculum.

## Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Understanding the Files](#understanding-the-files)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting started)
- [Usage](#usage)
- [Architecture Overview](#architecture-overview)
- [Documentation](#documentation)

## Overview

Inception is a multi-container Docker application that sets up a production-ready WordPress environment. It teaches fundamental concepts about containerization, orchestration, networking, and infrastructure-as-code through hands-on Docker and Docker Compose implementation.

## Project Structure

## Getting Started
1. Clone the repository:
   ```bash
   git clone https://github.com/YagoMartinez42/Inception.git
   cd Inception

Inception/ ├── Makefile # Build automation (8.4%) ├── srcs/ │ ├── docker-compose.yml # Service orchestration configuration │ ├── .env # Environment variables (not in repo) │ └── requirements/ │ ├── mariadb/ # MariaDB container definition │ ├── nginx/ # Nginx reverse proxy configuration │ ├── wordpress/ # WordPress PHP application │ └── bonus/ # Additional bonus services └── .gitignore # Git ignore rules


## Understanding the Files

This section explains each component pedagogically to help you understand how the project works.

### **Makefile**

The **Makefile** is a build automation script that simplifies common Docker operations using simple commands.

**Key Concepts:**
- **Variables**: Stores reusable values (`NAME`, `COMPOSE_ROUTE`, `VOLUMES`)
- **Targets**: Commands you can run with `make <target>`
- **Dependencies**: Automatically execute prerequisite targets

**What Each Target Does:**

| Target | Command | Purpose |
|--------|---------|---------|
| `make` or `make all` | `docker compose up -d` | Starts all services in detached mode |
| `make down` | `docker compose down` | Stops all running services |
| `make remove` | `docker compose down --rmi all --volumes` | Stops services and removes images/volumes (hard reset) |
| `make re` | `make remove && make all` | Full rebuild - removes everything and restarts |

**Example Usage:**
shell command:
make                   # Start everything
make down              # Stop everything
make remove            # Clean slate - delete all Docker artifacts
make re                # Complete restart

### docker-compose.yml (Located in srcs/)
This YAML configuration file defines all services in your application and how they interact. It's the blueprint for your entire infrastructure.

Key Concepts Explained:

1. Services (Lines 1-61): The building blocks of your application

mariadb: MySQL-compatible database server
wordpress: PHP application server
nginx: Web server and reverse proxy

2. Volumes: Persistent data storage

mariadb_data: Stores database files
wordpress_data: Stores WordPress files and uploads
Purpose: Ensures data survives container restarts

3. Networks: Internal communication

Services can only communicate with each other through this network
Isolates your application from the host system

4. Secrets: Secure sensitive information

Passwords stored in separate files, not hardcoded
Referenced by containers at runtime
Security Best Practice: Never commit secrets to Git
Service Dependencies & Health Checks:

# WordPress depends on MariaDB being healthy before starting
depends_on:
  mariadb:
    condition: service_healthy  # Waits for health check to pass
The healthcheck in MariaDB ensures:

Database is ready before WordPress connects
Prevents connection failures due to timing issues
Demonstrates infrastructure resilience patterns

### requirements/ Directory Structure
Each subdirectory contains a Dockerfile that builds a custom image for that service:

requirements/mariadb/
Purpose: Database layer
Image Base: MariaDB official image
Key Functions:
Initializes database schema
Sets up user accounts
Configures persistent storage
requirements/nginx/
Purpose: Reverse proxy and web server
Image Base: Alpine Linux + Nginx
Key Functions:
Listens on HTTPS (port 443)
Routes traffic to WordPress
Serves static files efficiently
requirements/wordpress/
Purpose: Application layer (PHP runtime)
Image Base: Alpine Linux + PHP-FPM
Key Functions:
Runs WordPress application
Connects to database
Generates dynamic content
requirements/bonus/
Purpose: Optional additional services
Examples: Redis caching, FTP server, etc.
Prerequisites
Before you begin, ensure you have:

Docker Engine: Version 20.10 or higher

Install Docker
Verify: docker --version
Docker Compose: Version 1.29 or higher (included with Docker Desktop)

Verify: docker compose version
System Requirements:

At least 2GB RAM available
1GB free disk space
Linux/macOS/Windows 10+ with WSL2
42 School Setup (if applicable):

Access to school's VM or Linux environment
Basic Unix command-line knowledge
Getting Started
1. Clone the Repository
bash
git clone https://github.com/YagoMartinez42/Inception.git
cd Inception
2. Configure Environment Variables
Create a .env file in the srcs/ directory with your configuration:

cd srcs
cat > .env << 'EOF'
# Database Configuration
MYSQL_DATABASE=wordpress_db
MYSQL_USER=wordpress_user
MYSQL_HOST=mariadb

# WordPress Configuration
WP_URL=https://localhost
WP_TITLE=My WordPress Site
WP_ADMIN_USER=admin
WP_ADMIN_EMAIL=admin@example.com
EOF

3. Create Secrets Directory
bash
mkdir -p srcs/secrets
Create secret files:

bash
# Database root password
echo "root_secure_password_123" > srcs/secrets/db_root_password.txt

# Database user password
echo "wordpress_user_password" > srcs/secrets/db_password.txt

# WordPress admin password
echo "admin_secure_password_456" > srcs/secrets/wp_admin_password.txt
4. Build and Start Services
bash
# From project root directory
make                    # Or: docker compose -f srcs/docker-compose.yml up -d

# Monitor startup
docker compose -f srcs/docker-compose.yml logs -f
5. Access Your WordPress
URL: https://localhost (or https://your-domain)
Admin Panel: https://localhost/wp-admin
Username: Value from WP_ADMIN_USER
Password: From srcs/secrets/wp_admin_password.txt