#!/usr/bin/bash
#===============================================================================
# Module:       tickets/init.sh
# Description:  Initialize tickets data file
#===============================================================================

TICKETS_FILE="$DATA_DIR/tickets.txt"

# Ensure tickets file exists with header
init_tickets_file() {
  if [[ ! -f "$TICKETS_FILE" ]]; then
    echo "ID|Title|Customer|Email|Phone|Status|Priority|Date" > "$TICKETS_FILE"
  fi
}

