#!/usr/bin/bash
#===============================================================================
# File:         tickets_menu.sh
# Description:  Support tickets management menu interface
#===============================================================================

# Main tickets menu loop
main_tickets_menu() {
  while true; do
    display_tickets_menu
    read -r -p "$(echo -e '\nEnter your choice (1-6): ')" choice
    
    case "$choice" in
      1)
        add_ticket_record
        ;;
      2)
        search_tickets
        ;;
      3)
        remove_ticket
        ;;
      4)
        view_all_tickets
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

# Display tickets menu
display_tickets_menu() {
  echo ""
  echo -e "${MAGENTA}========================================${NC}"
  echo -e "${MAGENTA}   SUPPORT TICKETS${NC}"
  echo -e "${MAGENTA}========================================${NC}"
  echo "Please choose an option:"
  echo "  1) Add New Ticket"
  echo "  2) Search Tickets"
  echo "  3) Remove Ticket(s)"
  echo "  4) View All Tickets"
  echo "  5) Return to Main Menu"
  echo "  6) Exit Application"
  echo -e "${MAGENTA}========================================${NC}"
}

