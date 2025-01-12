#!/bin/bash
# This script connects to a ysf/fcs reflector only if there has been no activity
# on the local repeater for the last 5 minutes.
#
# (c) 2025 Fernando KI5LKF - YSF
#
# Usage:
# $ ysfconnect.sh FCS00329 # This command will link to the reflector REF014_C.
# $ ysfconnect.sh          # This command will unlink from any reflector.

if [ ! -t 1 ]; then
  LOG="/var/log/pi-star/custom_switch.log"
  exec 2>>/tmp/web-graphs.log 1>&2
fi

# Variables
LOG_FILE="/var/log/pi-star/MMDVM-*.log"
INACTIVITY_THRESHOLD=300        # 5 minutes
REFLECTOR="${1:-unlink}"        # Desired reflector to switch to

# Get the last activity timestamp
last_activity=$(grep -i "RF header from" $LOG_FILE | tail -n 1 | awk '{print $3}')
last_activity_stamp=$(date -d "$last_activity" +%s 2>/dev/null || echo 0)

# Calculate inactivity duration
inactivity_duration=$(( ${last_activity_stamp} - $(date +%s) ))

# Check if inactivity duration exceeds threshold
if [ "$inactivity_duration" -ge "$INACTIVITY_THRESHOLD" ]; then
  # Switch reflector if inactive
  /usr/local/sbin/pistar-ysflink
  /usr/local/sbin/pistar-ysflink $REFLECTOR
  echo "$(date): Switched to $REFLECTOR due to last activity $last_activity"
else
  echo "$(date): No switch to $REFLECTOR - Activity detected within the last $INACTIVITY_THRESHOLD seconds"
fi