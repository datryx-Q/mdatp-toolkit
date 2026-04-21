#!/bin/bash
#################################################################
#
# SCRIPT: mde-quick-scan-mgmt.sh
# VERSION: 1.0
#
# PURPOSE: 
# Use script with infrastructure management tool to trigger 
# mdatp quick scan. Run quick scan in conjunction with 
# mdatp being in real-time protection mode. Scan should
# occur daily. 
#
#################################################################

# --- Configuration ---

LOG_DIR="/var/log/microsoft" # Infra mgmt tool may not have perms
LOG_FILE="$LOG_DIR/mdatp_quick_scan.log"
MAX_LOG_SIZE="1048576" # 1MB in bytes
SCAN_CMD="/usr/bin/mdatp scan quick"
HOSTNAME=$(hostname)

# Exit Codes
EXIT_SUCCESS=0
EXIT_MDATP_NOT_INSTALLED=1
EXIT_PERMISSIONS_DENIED=2
EXIT_SCAN_FAILED=3
EXIT_LOG_WRITE_FAILED=4
EXIT_DISK_SPACE_LOW=5

echo "Starting script..."

# Function to log messages
log_message() { 
    local DATE=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$DATE [$HOSTNAME] - $1" >> "$LOG_FILE" || { 
        echo "$DATE [$HOSTNAME] - ERROR: Failed to write to log file $LOG_FILE"
        exit $EXIT_LOG_WRITE_FAILED
    }
}

echo "Checking log directory..."

# Ensure log directory exists
if [ ! -d "$LOG_DIR" ]; then
    echo "log directory does not exist. Creating $LOG_DIR..."
    mkdir -p "$LOG_DIR" || {
        echo "ERROR: Failed to create log directory $LOG_DIR"
        exit $EXIT_PERMISSIONS_DENIED
    }
    echo "Log directory created."
fi

echo "Checking write permissions for log directory..."

# Check write permissions

if [ ! -w "$LOG_DIR" ]; then
    echo "ERROR: No write permissions to $LOG_DIR"
    exit $EXIT_PERMISSIONS_DENIED
fi

echo "Checking log file size..."

# Log truncation: if log file > 1MB; truncate file

if [ -f "$LOG_FILE" ] && [ $(stat -c%s "$LOG_FILE") -gt $MAX_LOG_SIZE ]; then
    : > "$LOG_FILE"
    echo "Log file exceeded $MAX_LOG_SIZE bytes. Truncating log file."
    log_message "INFO: Log file truncated due to size exceeding $MAX_LOG_SIZE bytes."
fi

echo "Checking disk space in $LOG_DIR..."

# Check disk space; -lt 10MB

DISK_FREE=$(df -k "$LOG_DIR" | awk 'NR==2 {print $4}')
if [ "$DISK_FREE" -lt 10240 ]; then 
    echo "ERROR: $LOG_DIR has less than 10MB free disk space ($DISK_FREE KB available). Quick scan not triggered."
    log_message "ERROR: $LOG_DIR has less than 10MB free disk space ($DISK_FREE KB available). Quick scan not triggered."
    exit $EXIT_DISK_SPACE_LOW
fi

echo "Checking if mdatp is installed..."

# Check if mdatp is installed 

if ! command -v mdatp >/dev/null 2>&1; then
    echo "ERROR: mdatp not installed. Quick scan not triggered."
    log_message "ERROR: mdatp not installed. Quick scan not triggered."
    exit $EXIT_MDATP_NOT_INSTALLED
fi

# --- Script Logic ---

echo "Starting quick scan with mdatp. This may take a few minutes..."

SCAN_OUTPUT=$($SCAN_CMD 2>&1)
SCAN_EXIT_CODE=$?

if [ $SCAN_EXIT_CODE -ne 0 ]; then
    echo "ERROR: Quick scan failed"
    echo "Scan output summary:"
    echo "$SCAN_OUTPUT" | tail -10 
    echo "For fule deailts, see log file: $LOG_FILE"
    log_message "ERROR: Quick scan failed. Output: $SCAN_OUTPUT"
    exit $EXIT_SCAN_FAILED
else
    echo "SUCCESS: Quick scan completed successfully."
    echo "scan output summary:"
    echo "$SCAN_OUTPUT" | tail -10 
    echo "Full scan details are logged in: $LOG_FILE"
    log_message "SUCCESS: Quick scan completed successfully."
    log_message "INFO: Quick scan results: $SCAN_OUTPUT"
fi
