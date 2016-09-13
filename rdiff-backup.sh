#!/bin/sh -e
# Use default shell (may be dash rather than bash on modern systems)
# Exit immediately on error

BACKUP_USER=backup
BACKUP_HOST=jump
BACKUP_DIR=/mnt/backups/host/

# Commands should be silent except for error messages
# Run with -v5 for debugging only
/usr/bin/rdiff-backup \
  --exclude-globbing-filelist='/root/backup-exclusions.txt' \
 / \
 ${BACKUP_USER}@${BACKUP_HOST}::${BACKUP_DIR} \
 2>&1 | grep -v 'does not match source$'
