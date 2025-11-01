#!/usr/bin/bash
#===============================================================================
# Module:       products/loader.sh
# Description:  Load all products module components
#===============================================================================

# Get module directory
PRODUCTS_MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source all module files in order
source "$PRODUCTS_MODULE_DIR/init.sh"
source "$PRODUCTS_MODULE_DIR/functions/add.sh"
source "$PRODUCTS_MODULE_DIR/functions/search.sh"
source "$PRODUCTS_MODULE_DIR/functions/view.sh"
source "$PRODUCTS_MODULE_DIR/functions/remove.sh"

