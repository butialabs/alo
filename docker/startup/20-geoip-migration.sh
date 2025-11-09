#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_success() {
    echo -e "${GREEN}[✓] $1${NC}"
}

log_error() {
    echo -e "${RED}[✗] $1${NC}"
}

log_info() {
    echo -e "${YELLOW}[i] $1${NC}"
}

# GeoIP Database Check
log_info "Checking GeoIP database..."
if [ ! -f /app/config/GeoLite2-City.mmdb ]; then
    log_info "GeoLite2-City.mmdb not found. Updating GeoIP database..."
    php /app/bin/alo geoip:update
    if [ $? -eq 0 ]; then
        log_success "GeoIP database updated successfully"
    else
        log_error "Failed to update GeoIP database"
    fi
else
    log_success "GeoIP database exists"
fi

# Wait for .env file (installation check)
check_env_file() {
    log_info "Checking for config file..."
    local attempt=1

    while true; do
        if [ -f /app/config/.env ]; then
            log_success "Config file found"
            return 0
        fi
        
        log_info "While waiting for the installation to finish, access /install... (Attempt $attempt)"
        sleep 60
        attempt=$((attempt+1))
    done
}

check_env_file

# Run database migrations
log_info "Running database migrations..."
php /app/bin/alo app:migration
if [ $? -eq 0 ]; then
    log_success "Database migrations completed successfully"
else
    log_error "Failed to run database migrations"
fi

echo -e "\n${GREEN}Alô: Initialized ===${NC}\n"