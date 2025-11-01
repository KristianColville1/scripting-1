#!/usr/bin/bash
#===============================================================================
# Module:       tickets/loader.sh
# Description:  Load all tickets module components
#===============================================================================

# Get module directory
TICKETS_MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source all module files in order
source "$TICKETS_MODULE_DIR/init.sh"
source "$TICKETS_MODULE_DIR/functions/add.sh"
source "$TICKETS_MODULE_DIR/functions/search.sh"
source "$TICKETS_MODULE_DIR/functions/view.sh"
source "$TICKETS_MODULE_DIR/functions/remove.sh"

