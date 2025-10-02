#!/bin/bash

# A script to back up all critical system configurations before a reinstall.

echo "--- Starting Arch Linux System Backup ---"

# Define the main backup directory
# All backups will be placed inside this folder.
BACKUP_DIR=~/Reinstall/system-backup

# --- Step 1: Create the backup directories ---
# The '-p' flag ensures parent directories are created without errors.
echo "Creating backup directory structure at $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR/etc-backup"

# --- Step 2: Save Package Lists (No sudo needed) ---
echo "Saving package lists..."
pacman -Qqe > ~/Reinstall/pkglist.txt
pacman -Qqm > ~/Reinstall/aur_pkglist.txt
npm list -g --depth=0 > ~/Reinstall/npm-global-packages.txt

# --- Step 3: Backup System Files (Requires sudo) ---
# The script will ask for your password once here.
echo "Backing up system configuration files (sudo password required)..."

# Essential configs
sudo cp /etc/pacman.conf "$BACKUP_DIR/etc-backup/"
sudo cp /etc/mkinitcpio.conf "$BACKUP_DIR/etc-backup/"
sudo cp /etc/fstab "$BACKUP_DIR/etc-backup/fstab.backup"

# GRUB theme and configs
sudo cp /etc/default/grub "$BACKUP_DIR/etc-backup/"
sudo cp -r /etc/grub.d/ "$BACKUP_DIR/etc-backup/"
sudo cp -r /boot/grub/themes/minegrub "$BACKUP_DIR/"

# Plymouth theme
sudo cp -r /usr/share/plymouth/themes/mc "$BACKUP_DIR/"

# Fingerprint reader configs (PAM and Udev rule)
sudo cp -r /etc/pam.d/ "$BACKUP_DIR/etc-backup/"
sudo cp /etc/udev/rules.d/50-fingerprint-powersave.rules "$BACKUP_DIR/"

# Custom low-battery script and its services
sudo cp /usr/local/bin/check-bat "$BACKUP_DIR/"
sudo cp /etc/systemd/system/check-bat.service "$BACKUP_DIR/"
sudo cp /etc/systemd/system/check-bat.timer "$BACKUP_DIR/"

# GDM custom settings
sudo cp /etc/gdm/custom.conf "$BACKUP_DIR/etc-backup/"

# TLP battery settings
sudo cp /etc/tlp.conf "$BACKUP_DIR/etc-backup/"

# UFW firewall rules for KDE Connect
sudo cp -r /etc/ufw/ "$BACKUP_DIR/etc-backup/"

# HP Printer configurations
sudo cp /etc/cups/printers.conf "$BACKUP_DIR/etc-backup/"
sudo cp -r /etc/cups/ppd/ "$BACKUP_DIR/etc-backup/"

echo "--- Backup Script Finished! ---"
echo "All backups are located in your ~/Reinstall directory."
