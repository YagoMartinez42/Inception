# User Documentation

This guide is intended for end users and administrators who need to interact with the Inception infrastructure. It provides straightforward instructions on understanding, operating, and managing the project stack.

## 1. Services Provided by the Stack

The project runs an isolated network composed of three interconnected services, each contained in its own Docker container:

- **Nginx (Web Proxy):** A reverse proxy taking requests on port `443` over highly encrypted HTTPS only. This service answers your browser's requests and passes them to WordPress.
- **WordPress (Web Application):** Operates on PHP-FPM to serve the Content Management System. This is where site content is rendered and styled.
- **MariaDB (Database):** A relational SQL database operating entirely offline from the outside world. It securely stores user posts, accounts, and application data.

All data is persistently saved to your host machine's hard drive using mapped volumes, meaning even if the containers turn off, your data remains intact.

## 2. Starting and Stopping the Project

We have included a `Makefile` at the root of the project to simplify everyday container management tasks.

- **Start the Stack**: 
  From the project root (`~/data/Inception` or wherever you cloned the repo), simply run:
  ```bash
  make
  ```
  *This automatically initializes directories, builds up images locally (which takes a minute the first time), and brings the infrastructure online entirely in the background.*

- **Stop the Stack**: 
  If you are done testing and want to pause the services:
  ```bash
  make down
  ```

- **Completely Wipe the Stack**:
  If you wish to terminate the environment completely (including dropping all the containers, images, and stored files natively attached to your database/WordPress installations), run:
  ```bash
  make remove
  ```

## 3. Accessing the Website and Administration Panel

The stack strictly uses the domain name configured for the server rather than local IPs. By default, this is set to **`samartin.42.fr`**.

*(Note: If you are running this locally on your laptop, you will need to map `samartin.42.fr` to `127.0.0.1` by editing your `/etc/hosts` file: `127.0.0.1 samartin.42.fr`).*

- **Public Website View**:
  Open your web browser and navigate to:
  `https://samartin.42.fr`
  *(You may need to bypass the security warning since the project uses self-signed TLS certificates for development purposes).*

- **Administration Panel**:
  To edit content, install themes, or add users, go to the WordPress backend:
  `https://samartin.42.fr/wp-admin`
  Log in using the administrator credentials configured in your secrets.

## 4. Locating and Managing Credentials

To increase the system's security profile, sensitive credentials are *not* stored directly inside configuration or environment files. Instead, they are passed into the containers using Docker Secrets.

As an administrator, you manage these inside the project repository under `srcs/secrets/`.
There are generally three specific files provided during configuration:
- `srcs/secrets/db_password.txt` (Password for the basic WordPress database system user)
- `srcs/secrets/db_root_password.txt` (Password for the all-powerful MariaDB Root user)
- `srcs/secrets/wp_admin_password.txt` (Password for the WordPress dashboard Administrator)

If you need to change a password, modify these text files *before* building the stack. Note that modifying these once the stack has already spun up for the first time won't actively apply the changes unless you completely wipe the stack (`make remove`) and rebuild, due to how databases lock their root parameters upon their initial instantiation.

## 5. Checking that the Services are Running Correctly

You can verify the health of the live services in a few different ways:

**Container Status**
Run the following command to see all active containers:
```bash
docker ps
```
You should see `mariadb`, `wordpress`, and `nginx` with a status of `Up`. (Noticeably, MariaDB includes a `(healthy)` indicator if the ping command we configured succeeds).

**Inspect Logs**
If something goes wrong (e.g. 502 Bad Gateway while accessing the domain), use the included `Makefile` rules to read the console output:
- `make logs-nginx`
- `make logs-wordpress`
- `make logs-mariadb`

**Accessing Individual Terminals**
If you need to peek "inside" the active server space for troubleshooting packages:
- `make access-nginx`
- `make access-wordpress`
- `make access-mariadb`
