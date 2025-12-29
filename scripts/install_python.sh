#! /usr/bin/env bash

set -euo pipefail

echo "[INFO] Installing Python"

sudo apt update
sudo apt install python3-pip -y

echo "[INFO] Installing UnixODBC and Microsoft ODBC Driver 18"

sudo apt-get update && sudo apt-get install -y unixodbc unixodbc-dev curl apt-transport-https gnupg
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/debian/10/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list > /dev/null
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql18

echo "[INFO] Installing pm2"
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install pm2 -g

echo "[INFO] Preparing backend setup variables"

# Accept DB server and DB name as positional args or from environment variables
DB_SERVER="${1:-${DB_SERVER:-todoappserversrv1.database.windows.net}}"
DB_NAME="${2:-${DB_NAME:-todoappdb}}"
DB_USER="${DB_USER:-sqladmin}"
DB_PASS="${DB_PASS:-P@ssw01rd@123}"

echo "[INFO] Using DB Server: $DB_SERVER"
echo "[INFO] Using DB Name: $DB_NAME"

echo "[INFO] Setting up Backend Application for First Time"

sudo -u sqladmin env DB_SERVER="$DB_SERVER" DB_NAME="$DB_NAME" DB_USER="$DB_USER" DB_PASS="$DB_PASS" bash -lc '
cd /home/sqladmin/
if [ ! -d todoapp-backend-py ]; then
	git clone https://github.com/devopsinsiders/todoapp-backend-py.git
fi
cd /home/sqladmin/todoapp-backend-py
cat > .env <<EOF
CONNECTION_STRING="Driver={ODBC Driver 18 for SQL Server};Server=tcp:$DB_SERVER,1433;Database=$DB_NAME;Uid=$DB_USER;Pwd=$DB_PASS;Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
EOF
python3 -m pip install -r requirements.txt
pm2 start app.py
' 
