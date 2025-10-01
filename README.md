# Projet Docker J3 - Stack Production-Ready
## Membres du groupe
- Chulee Bedos
- Sofiane Aboulkabila
## Architecture
Rails API + Next.js + PostgreSQL + Nginx
## Lancement
Voir les instructions dans ce README une fois le projet terminé.
#
# PostgreSQL Database Setup

### Quick Start

#### Production Environment
```bash
# Start PostgreSQL database
docker-compose up -d

# Run validation tests
./test-docker-compose.sh
```

#### Development Environment
```bash
# Start PostgreSQL + Adminer
./start-dev.sh

# Access Adminer at http://localhost:8080
# Connection details will be displayed in the terminal

# Stop development environment
./stop-dev.sh
```

### Services

- **PostgreSQL 16**: Main database service with initialization scripts
- **Adminer**: Web-based database administration tool (dev profile only)

### Connection Details

- **Host**: localhost (or `db` from within Docker network)
- **Port**: 5432 (PostgreSQL), 8080 (Adminer)
- **Database**: postgres
- **User**: postgres
- **Password**: stored in `secrets/db_password.txt`