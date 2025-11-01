#!/usr/bin/bash
#===============================================================================
# File:         main_menu.sh
# Description:  Main menu display and portal routing
#===============================================================================

# Display main menu
display_main_menu() {
  echo -e "${CYAN}========================================${NC}"
  echo -e "${CYAN}      MAIN MENU${NC}"
  echo -e "${CYAN}========================================${NC}"
  echo "Please choose a portal:"
  echo "  1) Products Management"
  echo "  2) Employee Management"
  echo "  3) Support Tickets"
  echo "  4) Orders Management"
  echo "  5) Exit"
  echo -e "${CYAN}========================================${NC}"
}

# Handle products portal navigation
handle_products_portal() {
  main_products_menu
}

# Handle employees portal navigation
handle_employees_portal() {
  main_employees_menu
}

# Handle tickets portal navigation
handle_tickets_portal() {
  main_tickets_menu
}

# Handle orders portal navigation
handle_orders_portal() {
  main_orders_menu
}

