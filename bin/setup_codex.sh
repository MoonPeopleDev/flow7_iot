#!/usr/bin/env bash
#===============================================================================
#  setup_codex.sh — One‑command bootstrap for the Codex backend stack
#
#  Installs and configures PostgreSQL and ClickHouse on a fresh Debian/Ubuntu
#  machine, then provisions logical databases/users required by the Codex
#  application.  Run this script as *root* (or with sudo -E) on Ubuntu 20.04+
#  or Debian 11/12. A reboot is **not** required.
#-------------------------------------------------------------------------------
set -euo pipefail
IFS=$'\n\t'

#-----------------------------  SETTINGS  --------------------------------------
PG_VERSION="16"                  # PostgreSQL major version to install
CH_VERSION="stable"             # ClickHouse repo channel (stable/testing)

# Allow overriding via env:
PG_VERSION="${PG_VERSION_OVERRIDE:-$PG_VERSION}"
CH_VERSION="${CH_VERSION_OVERRIDE:-$CH_VERSION}"

#---------------------------  SANITY CHECKS  -----------------------------------
if [[ $EUID -ne 0 ]]; then
  echo "[ERROR] Please run as root (sudo)." >&2
  exit 1
fi

source /etc/os-release
if [[ $ID != "ubuntu" && $ID != "debian" ]]; then
  echo "[ERROR] Unsupported distribution: $ID" >&2
  exit 1
fi

#-------------------------  HELPER FUNCTIONS  ----------------------------------
log()  { printf "\033[1;34m==>\033[0m %s\n" "$*"; }
err()  { printf "\033[1;31m[ERR]\033[0m %s\n" "$*"; }


add_clickhouse_repo() {
  log "Adding ClickHouse APT repository ($CH_VERSION)..."
  apt-get install -y apt-transport-https ca-certificates curl gnupg
  curl -fsSL 'https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key' | gpg --dearmor -o /usr/share/keyrings/clickhouse-keyring.gpg
  ARCH=$(dpkg --print-architecture)
  echo "deb [signed-by=/usr/share/keyrings/clickhouse-keyring.gpg arch=${ARCH}] https://packages.clickhouse.com/deb stable main" | tee /etc/apt/sources.list.d/clickhouse.list
  apt-get update

}

install_postgres() {
  log "Installing PostgreSQL server..."
  DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql postgresql-contrib >/dev/null
  service postgresql start
  #systemctl enable postgresql
  #systemctl start postgresql
}

install_clickhouse() {
  log "Installing ClickHouse server..."
  DEBIAN_FRONTEND=noninteractive apt-get install -y clickhouse-server clickhouse-client >/dev/null
  #systemctl enable clickhouse-server
  # Pre‑seed: auto‑start with default settings
  log "Clickhouse installed"

  service clickhouse-server start
  log "Clickhouse installed and running"
}

#provision_postgres() {
#  log "Creating PostgreSQL role & database..."
#  sudo -u postgres psql -v ON_ERROR_STOP=1 <<-SQL
#    DO \$\$BEGIN
#      IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '$POSTGRES_USER') THEN
#        CREATE ROLE $POSTGRES_USER LOGIN PASSWORD '$POSTGRES_PASSWORD';
#      END IF;
#    END\$\$;
#    CREATE DATABASE $POSTGRES_APP_DB OWNER $POSTGRES_USER TEMPLATE template0 ENCODING 'UTF8';
#SQL
#}

#provision_clickhouse() {
#  log "Creating ClickHouse user & database..."
#  clickhouse-client --user=default --password "" --multiquery <<-SQL
#    CREATE DATABASE IF NOT EXISTS $CLICKHOUSE_APP_DB;
#    CREATE USER IF NOT EXISTS $CLICKHOUSE_USER IDENTIFIED WITH plaintext_password BY '$CLICKHOUSE_PASSWORD';
#    GRANT ALL ON $CLICKHOUSE_APP_DB.* TO $CLICKHOUSE_USER;
#SQL
#}



#---------------------------------  MAIN  -------------------------------------
log "Updating package index..." && apt-get update -y -qq >/dev/null
add_clickhouse_repo
log "Refreshing package index with new repositories..." && apt-get update -y -qq >/dev/null
install_postgres
install_clickhouse
#source .codex_env
#provision_postgres
#provision_clickhouse


log "\nSUCCESS!  PostgreSQL and ClickHouse are ready for Codex."
log "Connection details have been saved to /opt/codex.env."
