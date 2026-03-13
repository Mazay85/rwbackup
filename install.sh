#!/bin/bash

set -e

INSTALL_DIR="/opt/rwbackup"

echo "Installing rwbackup..."

mkdir -p $INSTALL_DIR
mkdir -p /opt/backups

# download files
curl -fsSL https://raw.githubusercontent.com/Mazay85/rwbackup/main/rwbackup.sh -o $INSTALL_DIR/rwbackup.sh
curl -fsSL https://raw.githubusercontent.com/Mazay85/rwbackup/main/scripts/backup.sh -o $INSTALL_DIR/backup.sh

chmod +x $INSTALL_DIR/*.sh

# create command
ln -sf $INSTALL_DIR/rwbackup.sh /usr/local/bin/rwbackup

echo
echo "Installation complete!"
echo
echo "Run:"
echo "rwbackup"
