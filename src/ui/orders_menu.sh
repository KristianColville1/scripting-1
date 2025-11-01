#!/usr/bin/bash
#===============================================================================
# File:         orders_menu.sh
# Description:  Orders management menu interface
#===============================================================================

# Main orders menu loop
main_orders_menu() {
  while true; do
    display_orders_menu
    read -r -p "$(echo -e '\nEnter your choice (1-6): ')" choice
    
    case "$choice" in
      1)
        add_order_record
        ;;
      2)
        search_orders
        ;;
      3)
        remove_order
        ;;
      4)
        view_all_orders
        ;;
      5)
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

# Display orders menu
display_orders_menu() {
  echo ""
  echo -e "${MAGENTA}========================================${NC}"
  echo -e "${MAGENTA}   ORDERS MANAGEMENT${NC}"
  echo -e "${MAGENTA}========================================${NC}"
  echo "Please choose an option:"
  echo "  1) Add New Order"
  echo "  2) Search Orders"
  echo "  3) Remove Order(s)"
  echo "  4) View All Orders"
  echo "  5) Return to Main Menu"
  echo "  6) Exit Application"
  echo -e "${MAGENTA}========================================${NC}"
}

