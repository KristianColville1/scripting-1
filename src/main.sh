#!/usr/bin/bash
#===============================================================================
# Author:       Kristian Colville
# File:         main.sh
# Created:      2025
# Description:  Main entry point for Kristian's Cool Shop - Stock Control System
#               Multi-portal management system with Products, Employees, 
#               Support Tickets, and Orders management
#===============================================================================

set -o pipefail # safe failing for pipe operations

# ==================================================== 
# Configuration
# ====================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"
UI_DIR="$SCRIPT_DIR/ui"
UTILS_DIR="$SCRIPT_DIR/utils"
DATA_DIR="$SCRIPT_DIR/data"

# Ensure data directory exists
mkdir -p "$DATA_DIR"

# Source utility functions
source "$UTILS_DIR/validation.sh"
source "$UTILS_DIR/messages.sh"
source "$UTILS_DIR/table_formatter.sh"
source "$UTILS_DIR/batch_operations.sh"

# Source all modules via their loaders
source "$MODULES_DIR/products/loader.sh"
source "$MODULES_DIR/employees/loader.sh"
source "$MODULES_DIR/tickets/loader.sh"
source "$MODULES_DIR/orders/loader.sh"

# Source UI components
source "$UI_DIR/main_menu.sh"
source "$UI_DIR/products_menu.sh"
source "$UI_DIR/employees_menu.sh"
source "$UI_DIR/tickets_menu.sh"
source "$UI_DIR/orders_menu.sh"

# ==================================================== 
# Main script logic
# ====================================================

# Display welcome banner
display_welcome_banner

# Main loop
while true; do
  display_main_menu
  read -r -p "$(echo -e '\nEnter your choice (1-5): ')" choice
  
  case "$choice" in
    1)
      clear_screen
      handle_products_portal
      ;;
    2)
      clear_screen
      handle_employees_portal
      ;;
    3)
      clear_screen
      handle_tickets_portal
      ;;
    4)
      clear_screen
      handle_orders_portal
      ;;
    5|[Ee][Xx][Ii][Tt]|[Qq])
      echo ""
      display_message "info" "Thank you for using Kristian's Cool Shop Management System!"
      echo "Goodbye!"
      exit 0
      ;;
    *)
      clear_screen
      display_message "error" "Invalid option. Please try again."
      sleep 1
      ;;
  esac
  echo ""
done

# End of script

