#!/usr/bin/bash
#===============================================================================
# Module:       employees/init.sh
# Description:  Initialize employees data file
#===============================================================================

EMPLOYEES_FILE="$DATA_DIR/employees.txt"

# Ensure employees file exists with header
init_employees_file() {
  if [[ ! -f "$EMPLOYEES_FILE" ]]; then
    echo "ID|Name|Role|Department|Email|Phone|HireDate" > "$EMPLOYEES_FILE"
  fi
}

