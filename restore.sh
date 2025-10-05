#!/bin/bash

# A script to restore all critical system configurations after a reinstall.

echo "--- Starting Arch Linux System Restore ---"
echo "This script will copy backed-up files to their system locations."

# Define the main backup directory
BACKUP_DIR=~/Reinstall/system-backup

# --- Step 1: Restore System Files (Requires sudo) ---
echo "Restoring system files (sudo password required)..."

# Essential configs
sudo cp "$BACKUP_DIR/etc-backup/pacman.conf" /etc/
sudo cp "$BACKUP_DIR/etc-backup/mkinitcpio.conf" /etc/
sudo cp "$BACKUP_DIR/etc-backup/fstab.backup" /etc/fstab

# GRUB theme and configs
sudo cp "$BACKUP_DIR/etc-backup/grub" /etc/default/
sudo cp -r "$BACKUP_DIR/etc-backup/grub.d/" /etc/
sudo cp -r "$BACKUP_DIR/minegrub" /boot/grub/themes/

# Plymouth theme
sudo cp -r "$BACKUP_DIR/mc" /usr/share/plymouth/themes/

# Fingerprint reader configs
sudo cp -r "$BACKUP_DIR/etc-backup/pam.d/" /etc/
sudo cp "$BACKUP_DIR/50-fingerprint-powersave.rules" /etc/udev/rules.d/

# Custom low-battery script and its services
sudo cp "$BACKUP_DIR/check-bat" /usr/local/bin/
sudo cp "$BACKUP_DIR/check-bat.service" /etc/systemd/system/
sudo cp "$BACKUP_DIR/check-bat.timer" /etc/systemd/system/

# GDM custom settings
sudo cp "$BACKUP_DIR/etc-backup/custom.conf" /etc/gdm/

# TLP battery settings
sudo cp "$BACKUP_DIR/etc-backup/tlp.conf" /etc/

# UFW firewall rules
sudo cp -r "$BACKUP_DIR/etc-backup/ufw/" /etc/

# HP Printer configurations
sudo cp "$BACKUP_DIR/etc-backup/printers.conf" /etc/cups/
sudo cp -r "$BACKUP_DIR/etc-backup/ppd/" /etc/cups/

echo "--- File restoration complete! ---"
echo "Now, rebuilding system images and enabling services..."

# --- Step 2: Rebuild and Re-enable ---
# Rebuild the boot image with the restored mkinitcpio.conf
sudo mkinitcpio -P

# Rebuild the GRUB config with the restored theme settings
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Re-enable your custom timer and other essential services
sudo systemctl enable ufw.service
sudo systemctl enable cups.service
sudo systemctl reenable check-bat.timer # Use reenable to ensure it's unmasked and enabled

# You may need to enable GDM and NetworkManager manually if not already done
# sudo systemctl enable gdm.service
# sudo systemctl enable NetworkManager.service

echo "--- Restore Script Finished! ---"
echo "It is highly recommended to REBOOT NOW."
