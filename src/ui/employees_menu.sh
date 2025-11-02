#!/usr/bin/bash
#===============================================================================
# File:         employees_menu.sh
# Description:  Employee management menu interface
#===============================================================================

# Main employees menu loop
main_employees_menu() {
  while true; do
    clear_screen
    display_employees_menu
    read -r -p "$(echo -e '\nEnter your choice (1-6): ')" choice
    
    case "$choice" in
      1)
        add_employee_record
        ;;
      2)
        search_employees
        ;;
      3)
        remove_employee
        ;;
      4)
        view_all_employees
        ;;
      5)
        clear_screen
        return 0  # Return to main menu
        ;;
      6|[Ee][Xx][Ii][Tt])
        echo ""
        display_message "info" "Thank you for using Kristian's Cool Shop Management System!"
        echo "Goodbye!"
        exit 0
        ;;
      *)
        display_message "error" "Invalid option. Please try again."
        sleep 1
        ;;
    esac
    echo ""
  done
}

# Display employees menu
display_employees_menu() {
  echo ""
  echo -e "${MAGENTA}========================================${NC}"
  echo -e "${MAGENTA}   EMPLOYEE MANAGEMENT${NC}"
  echo -e "${MAGENTA}========================================${NC}"
  echo "Please choose an option:"
  echo "  1) Add New Employee"
  echo "  2) Search Employees"
  echo "  3) Remove Employee(s)"
  echo "  4) View All Employees"
  echo "  5) Return to Main Menu"
  echo "  6) Exit Application"
  echo -e "${MAGENTA}========================================${NC}"
}

