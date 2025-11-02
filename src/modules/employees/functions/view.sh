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
    sleep 2
    return 0
  fi
  
  clear_screen
  echo -e "\n${CYAN}--- All Employees ---${NC}"
  format_table "$EMPLOYEES_FILE" "yes"
  read -r -p "Press Enter to continue..."
}

