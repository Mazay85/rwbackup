#!/bin/bash

INSTALL_DIR="/opt/rwbackup"

clear

echo "Remnawave Backup Tool"
echo
echo "1. Backup"
echo "2. Exit"
echo

read -p "Select option: " OPTION

case $OPTION in
1)
bash $INSTALL_DIR/backup.sh
;;
*)
exit
;;
esac
