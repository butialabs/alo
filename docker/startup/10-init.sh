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

echo -e "\n${YELLOW}Alô: Initializing${NC}\n"

# Set Workers environment variable
if [ -z "$WORKERS" ]; then
    log_info "No WORKERS environment variable set, using 1 as default"
    export WORKERS=1
else
    log_success "Using $WORKERS worker(s)"
fi

# Adjust directory permissions
log_info "Adjusting directory permissions..."

mkdir -p /app/config
chown -R www-data:www-data /app/config
chmod -R 775 /app/config

log_success "Permissions adjusted"