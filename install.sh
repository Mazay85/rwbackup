#!/bin/bash

set -e

INSTALL_DIR="/opt/rwbackup"

mkdir -p $INSTALL_DIR
mkdir -p /opt/backups

echo "Installing rwbackup..."

curl -fsSL https://raw.githubusercontent.com/Mazay85/rwbackup/main/rwbackup.sh \
-o $INSTALL_DIR/rwbackup.sh

curl -fsSL https://raw.githubusercontent.com/Mazay85/rwbackup/main/scripts/backup.sh \
-o $INSTALL_DIR/backup.sh

chmod +x $INSTALL_DIR/*.sh

ln -sf $INSTALL_DIR/rwbackup.sh /usr/local/bin/rwbackup

echo
echo "Installed successfully"
echo "Run: rwbackup"
