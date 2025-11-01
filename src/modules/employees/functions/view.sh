#!/usr/bin/bash
#===============================================================================
# Module:       employees/view.sh
# Description:  View and display employees using generic table formatter
#===============================================================================

# View all employees
view_all_employees() {
  init_employees_file
  
  if [[ ! -s "$EMPLOYEES_FILE" ]]; then
    display_message "warning" "No employees found in database."
    return 0
  fi
  
  echo -e "\n${CYAN}--- All Employees ---${NC}"
  format_table "$EMPLOYEES_FILE" "yes"
}

