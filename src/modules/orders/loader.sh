#!/usr/bin/bash
#===============================================================================
# Module:       orders/loader.sh
# Description:  Load all orders module components
#===============================================================================

# Get module directory
ORDERS_MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source all module files in order
source "$ORDERS_MODULE_DIR/init.sh"
source "$ORDERS_MODULE_DIR/functions/add.sh"
source "$ORDERS_MODULE_DIR/functions/search.sh"
source "$ORDERS_MODULE_DIR/functions/view.sh"
source "$ORDERS_MODULE_DIR/functions/remove.sh"

