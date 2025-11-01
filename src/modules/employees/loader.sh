#!/usr/bin/bash
#===============================================================================
# Module:       employees/loader.sh
# Description:  Load all employees module components
#===============================================================================

# Get module directory
EMPLOYEES_MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source all module files in order
source "$EMPLOYEES_MODULE_DIR/init.sh"
source "$EMPLOYEES_MODULE_DIR/functions/add.sh"
source "$EMPLOYEES_MODULE_DIR/functions/search.sh"
source "$EMPLOYEES_MODULE_DIR/functions/view.sh"
source "$EMPLOYEES_MODULE_DIR/functions/remove.sh"

