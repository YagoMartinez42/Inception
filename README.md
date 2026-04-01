*This project has been created as part of the 42 curriculum by samartin*

## Description

The Inception project aims to broaden our knowledge of system administration by deploying multiple Docker containers. The goal is to build a small, isolated infrastructure composed of different services running inside specialized containers, which serves as an excellent introduction to DevOps and containerization.

This infrastructure is built using Docker and Docker Compose. Rather than using pre-built service images, every service is constructed from Alpine or Debian-based images via custom Dockerfiles, ensuring a deep understanding of how each component is installed, configured, and orchestrated.

The specific sources included in this project, which run in their own individual, interconnected containers, are:
- **Nginx**: A dedicated web server configured to accept HTTPS connections (using TLSv1.2 or TLSv1.3) only, acting as the sole entrypoint to our infrastructure on port 443.
- **WordPress**: A PHP-FPM service running the popular Content Management System, optionally configured via WP-CLI.
- **MariaDB**: The relational database management system used by WordPress to store its persistent data.

### Main Design Choices & Comparisons

#### Virtual Machines vs Docker
Virtual Machines (VMs) emulate an entire physical computer, including a full guest Operating System on top of a hypervisor. They provide strong isolation but consume significant disk arrays and RAM, and have slower boot times. Docker, contrarily, is a containerization technology that virtualizes only the OS layer. Containers share the host's kernel, making them extremely lightweight, fast to start, and far less resource-intensive. For this project, Docker is the ideal choice to spin up distinct microservices without the heavy overhead associated with multiple VMs.

#### Secrets vs Environment Variables
Environment variables (`.env` files or hardcoded `environment` directives) are commonly used to pass configuration settings (like `MYSQL_DATABASE`) into a container. However, they can be insecure for sensitive data because they are easily exposed through crash logs, container inspection (`docker inspect`), and sub-processes. Docker Secrets provide a secure, encrypted mechanism for managing highly sensitive information like passwords. Secrets are mounted as temporary in-memory files (e.g., at `/run/secrets/`), inherently preventing them from being accidentally leaked through environment variables. In our architecture, critical credentials like the database root password and WordPress admin passwords are securely managed using specific Docker Compose secrets.

#### Docker Network vs Host Network
Running a container on the host network means it shares the entire network stack of the host machine directly. This severely breaks container isolation, bypasses container orchestration security, and can easily lead to port conflicts locally. Utilizing a custom Docker Network—specifically, a user-defined bridge network named `inception`—creates an isolated, internal network for our containers that provides automatic DNS resolution. This ensures that services like `wordpress` can communicate safely with `mariadb` using their container names as hostnames without ever exposing their internal ports to the host machine. Only our Nginx proxy has port 443 explicitly mapped to the host.

#### Docker Volumes vs Bind Mounts
Bind mounts define an explicit, absolute path on the host system to be matched completely with a directory inside the container, making the host tightly coupled and occasionally introducing file permission issues. Standard Docker Volumes are abstract storage endpoints fully managed by Docker within a dedicated hidden host directory (e.g. `/var/lib/docker/volumes/`). While volumes are generally more abstract, secure, and easier to manage, this project requires storing persistent data at specific, predefined host paths (`/home/${USER}/data/`). To achieve the best of both, we declare local volume drivers with bind options (`device`, `o: bind`), allowing us to utilize Docker's volume lifecycle features while fulfilling the explicit location constraints.

## Instructions

To build, deploy, and manage the project infrastructure, a `Makefile` is provided at the root of the repository.

### Prerequisites
- Docker and Docker Compose must be installed on your machine.
- `make` must be installed.
- You must have user permissions to modify or create the data directories (`/home/${USER}/data/mariadb` and `/home/${USER}/data/wordpress` will be created automatically).

### Deployment and Execution

1. **Build and Start the Infrastructure**:
   Execute the default make rule at the root of the project:
   ```bash
   make
   ```
   This rule will spawn the necessary local data folders, build the container images from the Dockerfiles found within the `srcs/requirements` directories, and run all the containers detached in the background.

2. **Restart Existing Containers**:
   To start the containers without triggering a full rebuild:
   ```bash
   make up
   ```

3. **Stop the Containers**:
   Gracefully power down the active infrastructure:
   ```bash
   make down
   ```

4. **Clean up (Teardown)**:
   To stop the containers, tear down the custom network, remove all generated images, internal volumes, and permanently delete all persistent storage from the host:
   ```bash
   make remove
   ```

5. **Full Rebuild**:
   To clean everything and restart from scratch:
   ```bash
   make re
   ```

**Debugging**:
The Makefile includes specific targets for debugging individual services:
- View logs: `make logs-nginx`, `make logs-wordpress`, `make logs-mariadb`
- Access shells: `make access-nginx`, `make access-wordpress`, `make access-mariadb`

## Resources
References and documentations utilized to successfully prepare this infrastructure:
- [Docker Engine Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Nginx Official Documentation](https://nginx.org/en/docs/)
- [MariaDB Official KB Documentation](https://mariadb.com/kb/en/documentation/)
- [WordPress Developer Resources](https://developer.wordpress.org/)
- [WP-CLI Handbook](https://make.wordpress.org/cli/handbook/)

AI was used to validate references from existing Inception guidelines and adapt them to the needs of this version, mostly the differences between Debian and Alpine Linux. AI was also used to redact most of the content of this README.md file.